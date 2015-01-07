require 'securerandom'
require 'sidekiq/batch/status'
require 'sidekiq/batch/middleware'
require 'sidekiq/batch/client'

module Sidekiq
  ##
  # Provide a higher-level Batch abstraction for units of work.
  # Given a set of work, we want to break the set down to individual jobs
  # for Sidekiq to process in parallel but then have an overall
  # notification when the entire set is complete.
  #
  #   batch = Sidekiq::Batch.new
  #   batch.on(:complete, self.class, :to => current_user.email)
  #   batch.jobs do
  #     # push messages to sidekiq
  #   end
  #
  # Sidekiq generates a unique Batch ID, along with the number of jobs pushed
  # in the batch.  Note that Batches do not support client-side sharding.
  #
  class Batch
    class NoSuchBatch < StandardError; end

    EXPIRY = 60 * 60 * 24 * 3
    MAX_EXPIRY = 60 * 60 * 24 * 30
    VALID_EVENTS = %w(complete success)

    attr_reader :expiry
    attr_reader :created_at
    attr_reader :bid
    attr_reader :callbacks
    attr_accessor :description

    def initialize(bid=nil)
      @pool = Sidekiq::Client.new.redis_pool
      if bid
        @bid = bid
        msg = redis do |conn|
          conn.get("b-#{bid}")
        end
        raise NoSuchBatch, "Couldn't find Batch #{bid} in redis" unless msg
        props = Sidekiq.load_json(msg)
        @expiry = props['expiry'] || EXPIRY
        @created_at = props['created_at']
        @callbacks = props['callbacks']
        @description = props['description']
        @mutable = false
      else
        @bid = SecureRandom.hex(8)
        @created_at = Time.now.utc.to_f
        @callbacks = {}
        @expiry = EXPIRY
        @mutable = true
      end
    end

    ##
    # Set the time until the batch's data will expiry in Redis.
    # Default is three days.  If your batches might take longer
    # to fully process, set this value higher:
    #
    #   batch.expires_in 15.days
    #
    # If you create a LOT of batches, you might want to set this
    # value lower so the data is more aggressively pruned from Redis.
    #
    def expires_in(val)
      raise "Batch cannot be modified, jobs have already been defined" unless @mutable
      v = val.to_i
      raise "Invalid expiration: #{v}" unless v > 0 && v <= MAX_EXPIRY
      @expiry = v
    end

    def expires_at
      Time.at(@created_at + @expiry)
    end

    ##
    # Set up a notification to run when the batch is complete.
    # Example:
    #
    #   batch.notify(:campfire)
    #   batch.notify(:email, :to => current_user.email)
    #
    # @deprecated Use your own on(event) callback instead.
    def notify(type, options={})
      raise "Batch cannot be modified, jobs have already been defined" unless @mutable
      Sidekiq.logger.info("Batch#notify is deprecated, use an on(:complete) callback instead.")
      on(:complete, Sidekiq::Notifications.get(type.to_sym), options)
    end

    # Retrieve the complete set of JIDs associated with this batch.
    def jids
      redis do |conn|
        conn.smembers("b-#{bid}-jids")
      end
    end

    def include?(jid)
      redis do |conn|
        conn.sismember("b-#{bid}-jids", jid)
      end
    end
    alias_method :valid?, :include?

    def invalidate_all
      redis do |conn|
        conn.del("b-#{bid}-jids")
      end
    end

    def invalidate_jids(*jids)
      redis do |conn|
        conn.srem("b-#{bid}-jids", jids)
      end
    end

    # TODO deprecated, remove in 2.0
    def remove_jobs(*jids)
      puts "[DEPRECATED] Sidekiq::Batch#remove_jobs has been renamed to invalidate_jids"
      invalidate_jids(*jids)
    end

    def status
      Status.new(@bid)
    end

    def mutable?
      !!@mutable
    end

    ##
    # Call a method upon completion or success of a batch.  You
    # may pass a bare Class, which will call "on_#{event}", or a
    # String with the exact 'Class#method' to call.
    #
    #   batch.on(:complete, MyClass)
    #   batch.on(:success, 'MyClass#foo')
    #   batch.on(:complete, MyClass, :email => current_user.email)
    #
    # The Class should implement a method signature like this:
    #
    #   def on_complete(status, options)
    #   end
    #
    def on(event, call, options={})
      raise "Batch cannot be modified, jobs have already been defined" unless @mutable
      e = event.to_s
      raise ArgumentError, "Invalid event name: #{e}" unless VALID_EVENTS.include?(e)

      @callbacks ||= {}
      @callbacks[e] ||= []
      @callbacks[e] << { call => options }
    end

    ##
    # Pass in a block which pushes all the work associated
    # with this batch to Sidekiq.
    #
    # Returns the set of JIDs added to the batch.
    #
    # Note: all jobs defined within the block are pushed to Redis atomically
    # so either the entire set of jobs are defined successfully or none at all.
    def jobs(&block)
      raise ArgumentError, "Must specify a block" if !block
      Thread.current[:sidekiq_batch_payloads] = []

      @mutable = false
      @added = []

      redis do |conn|
        conn.setex("b-#{bid}", @expiry, Sidekiq.dump_json(:created_at => created_at,
                                                         :callbacks => callbacks,
                                                         :description => description,
                                                         :expiry => expiry,
                                                         :bid => bid))
      end

      begin
        Thread.current[:sidekiq_batch] = self
        block.call
      ensure
        Thread.current[:sidekiq_batch] = nil
      end

      redis do |conn|
        conn.multi do
          # support pre-1.4 batch data where the score is the created_at time, not expiry time.
          # Prune conservatively.  TODO Change this to just `Time.now` in a few months.
          conn.zremrangebyscore('batches', '-inf', Time.now.to_f - 60*60*24)
          conn.zadd('batches', @created_at + @expiry, bid)
          Sidekiq::Client.default.flush(conn)
        end
      end
      @added
    ensure
      Thread.current[:sidekiq_batch_payloads] = nil
    end

    # Not a public API
    def register(jid) # :nodoc:
      redis do |conn|
        conn.multi do
          conn.incr("b-#{bid}-pending")
          conn.expire("b-#{bid}-pending", @expiry)
          conn.incr("b-#{bid}-total")
          conn.expire("b-#{bid}-total", @expiry)
          conn.sadd("b-#{bid}-jids", jid)
          conn.expire("b-#{bid}-jids", @expiry)
        end
      end
      @added << jid
    end

    private

    def redis(&block)
      @pool.with(&block)
    end
  end

end
