module Sidekiq
  class Batch
    ##
    # A snapshot in time of the current Batch status.
    #
    # * total - number of jobs in this batch.
    # * pending - number of jobs which have not reported success yet.
    # * failures - number of jobs which have failed.
    #
    # Batch job(s) can fail and be retried through Sidekiq's retry feature.
    # For this reason, a batch is considered complete once all jobs have
    # been executed, even if one or more executions was a failure.
    class Status
      attr_reader :bid
      attr_reader :total
      attr_reader :pending
      attr_reader :failures
      attr_reader :created_at
      attr_reader :expiry
      attr_reader :description
      attr_reader :callbacks

      def initialize(bid)
        @pool = Sidekiq::Client.new.redis_pool
        @bid = bid
        msg = redis do |conn|
          conn.get("b-#{bid}")
        end
        raise NoSuchBatch, "Couldn't find Batch #{bid} in redis" unless msg
        props = Sidekiq.load_json(msg)
        @created_at = Time.at(props['created_at'])
        @callbacks = props['callbacks']
        @description = props['description']
        @expiry = props['expiry'] || EXPIRY
        @pending, @total, @failures = redis do |conn|
          conn.multi do
            conn.get("b-#{bid}-pending")
            conn.get("b-#{bid}-total")
            conn.hlen("b-#{bid}-failinfo")
          end
        end.map(&:to_i)
      end

      def expires_at
        @created_at + @expiry
      end

      # Remove all info about this batch from Redis.
      # Note that Batch data naturally expires after 24 hours,
      # you don't need to use this normally.
      #
      # Returns the bid if anything was deleted, nil if nothing was deleted.
      def delete
        result, _ = redis do |conn|
          conn.multi do
            conn.del "b-#{bid}",
                     "b-#{bid}-pending",
                     "b-#{bid}-total",
                     "b-#{bid}-failinfo",
                     "b-#{bid}-jids"
            conn.zrem('batches', bid)
          end
        end
        result > 0 ? bid : nil
      end

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

      def success_pct
        return 0 if @total == 0
        ((@total - @pending) / Float(@total)) * 100
      end

      def pending_pct
        return 0 if @total == 0
        ((@pending - @failures) / Float(@total)) * 100
      end

      def failure_pct
        return 0 if @total == 0
        (@failures / Float(@total)) * 100
      end

      # A Batch is considered complete when no jobs are pending or
      # the only pending jobs have already failed.
      def complete?
        pending == failures
      end

      def join
        poll
      end

      def poll(polling_sleep = 1)
        while true
          @pending, @failures = redis do |conn|
            conn.multi do
              conn.get("b-#{bid}-pending")
              conn.hlen("b-#{bid}-failinfo")
            end
          end.map(&:to_i)
          break if complete?
          sleep polling_sleep
        end
      end

      Failure = Struct.new(:jid, :error_class, :error_message, :backtrace)

      # Batches store job failure info in a Hash, keyed off the bid.
      # The Hash contains { jid => [class name, error message] }
      def failure_info
        failures = redis {|conn| conn.hgetall("b-#{bid}-failinfo") }
        failures.map {|jid, json| Failure.new(jid, *Sidekiq.load_json(json)) }
      end

      def data
        {
          :is_complete => pending == failures,
          :bid => bid,
          :total => total,
          :pending => pending,
          :description => description,
          :failures => failures,
          :created_at => created_at.to_f,
          :fail_info => failure_info.map do |fail|
            { :jid => fail.jid, :error_class => fail.error_class, :error_message => fail.error_message, :backtrace => fail.backtrace }
          end
        }
      end

      def to_json
        Sidekiq.dump_json data
      end

      private

      def redis(&block)
        @pool.with(&block)
      end
    end
  end
end
