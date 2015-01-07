require 'sidekiq/util'
require 'sidekiq/actor'

module Sidekiq::Pro
  ##
  # Provides reliable queue processing via Redis' rpoplpush command.
  #
  # 1. retrieve the work while pushing it to our private queue for this process.
  # 2. process the work
  # 3. acknowledge the work by removing it from our private queue
  #
  # If we crash during this process, upon restart we'll pull any existing work from
  # the private queue and work on that first, effectively recovering the messages that
  # were processing during the crash.
  class ReliableFetch

    # Each Sidekiq process will poll Redis every 10 seconds for any queues which have
    # been (un)paused.
    #
    # TODO
    # Using an entire thread and polling is less than ideal.
    # Possibly convert this to use pubsub?
    class PausePoller
      include Sidekiq::Actor
      include Sidekiq::Util

      def initialize(fetcher)
        @fetcher = fetcher
      end

      def check(prev=[])
        cur = prev
        begin
          cur = Sidekiq.redis { |conn| conn.smembers('paused') }
          if cur != prev
            news = cur - prev
            logger.info("Pausing queue: #{news.inspect}") if !news.empty?
            olds = prev - cur
            logger.info("Unpausing queue: #{olds.inspect}") if !olds.empty?
            @fetcher.paused = cur
          end
        rescue => ex
          # ignore and try again later
          handle_exception(ex)
        end
        after(10) do
          check(cur)
        end
      end
    end

    attr_accessor :options
    attr_accessor :paused

    def initialize(options)
      raise ArgumentError, "reliable fetch requires a process index option" if !options[:index].is_a?(Integer)
      Sidekiq.logger.info("ReliableFetch activated")

      @queues = self.class.get_queues(options)
      @options = options
      @algo = (@queues.length == @queues.uniq.length ? Strict : Weighted)

      @pauser = PausePoller.new(self)
      @pauser.check

      # Heroku can get into a situation where the old and new process
      # are running concurrently.  Sleep 5 sec to better ensure the old
      # process is dead before we take jobs from the internal queue.
      sleep(5) if ENV['DYNO']

      @internal = Sidekiq.redis do |conn|
        bulk_reply = conn.pipelined do
          @queues.each do |(_, working_queue)|
            conn.lrange(working_queue, 0, -1)
          end
        end
        memo = []
        bulk_reply.each_with_index do |vals, i|
          queue = @queues[i][0]
          working_queue = @queues[i][1]
          memo.unshift(*vals.map do |msg|
            [queue, working_queue, msg]
          end)
        end
        memo
      end
      Sidekiq.logger.warn("ReliableFetch: recovering work on #{@internal.size} messages") if @internal.size > 0
    end

    def active_queues
      if self.paused
        @queues = (options[:queues] - paused).map {|q| ["queue:#{q}", self.class.private_queue(q, options)] }
        self.paused = nil
      end
      @queues
    end

    def retrieve_work
      if @internal.size > 0
        (queue, working_queue, msg) = @internal.pop
        UnitOfWork.new(queue, msg, working_queue)
      else
        @algo.call(active_queues)
      end
    end

    def self.bulk_requeue(in_progress, options)
      # Ignore the in_progress arg passed in; rpoplpush let's us know everything in process
      Sidekiq.redis do |conn|
        get_queues(options).each do |(queue, working_queue)|
          while conn.rpoplpush(working_queue, queue)
            Sidekiq.logger.info {"Moving work from #{working_queue} back to #{queue}"}
          end
        end
      end
    end

    private

    def self.private_queue(q, options)
      if ENV['DYNO']
        # Running on Heroku, hostnames are not predictable or stable.
        "queue:#{q}_#{options[:index]}"
      else
        "queue:#{q}_#{Socket.gethostname}_#{options[:index]}"
      end
    end

    def self.get_queues(options)
      options[:queues].map {|q| ["queue:#{q}", private_queue(q, options)] }
    end

    # In a weighted ordering, treat the queues like we're drawing
    # a queue out of a hat: draw a queue, attempt to fetch work.
    # Draw another queue, attempt to fetch work.
    Weighted = lambda {|queues|
      queues = queues.shuffle
      Sidekiq.redis do |conn|
        until queues.empty?
          queue, working_queue = queues.shift
          # On the last queue, block to avoid spinning 100% of the CPU checking for jobs thousands of times per
          # second when no jobs are enqueued at all. The above shuffle will randomize the queue blocked on each time.
          # Queues with higher weights should still get blocked on more frequently since they should end up as the
          # last queue in queues more frequently.
          if queues.length == 0
            result = (queue ? conn.brpoplpush(queue, working_queue, Sidekiq.options[:fetch_timeout] || 1) : (sleep(1); nil))
          else
            result = conn.rpoplpush(queue, working_queue)
          end
          return UnitOfWork.new(queue, result, working_queue) if result
        end
      end
    }

    Strict = lambda {|queues|
      Sidekiq.redis do |conn|
        if queues.length > 1
          queues.each do |(queue, working_queue)|
            result = conn.rpoplpush(queue, working_queue)
            return UnitOfWork.new(queue, result, working_queue) if result
          end
        end
        queue, working_queue = queues.first
        result = (queue ? conn.brpoplpush(queue, working_queue, Sidekiq.options[:fetch_timeout] || 1) : (sleep(1); nil))
        return UnitOfWork.new(queue, result, working_queue) if result
      end
    }

    UnitOfWork = Struct.new(:queue, :message, :local_queue) do
      def acknowledge
        Sidekiq.redis {|conn| conn.lrem(local_queue, -1, message) }
      end

      def queue_name
        queue.gsub(/.*queue:/, '')
      end

      def requeue
        # no worries, mate, rpoplpush got our back!
      end
    end

  end
end

Sidekiq.options[:fetch] = Sidekiq::Pro::ReliableFetch
Sidekiq.options[:index] ||= 0 if Sidekiq.options[:environment] != 'production'
Array(Sidekiq.options[:labels]) << 'reliable'
