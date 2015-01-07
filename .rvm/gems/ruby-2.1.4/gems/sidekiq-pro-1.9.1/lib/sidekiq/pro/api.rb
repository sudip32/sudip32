require 'sidekiq/api'
require 'sidekiq/pro/scripting'

module Sidekiq
  def self.redis_version
    @redis_version ||= Sidekiq.redis {|c| c.info["redis_version"] }
  end

  class Queue
    # Delete a job from the given queue.
    def delete_job(jid)
      raise ArgumentError, "No JID provided" unless jid
      Sidekiq::Pro::Scripting.call(:queue_delete_by_jid, ["queue:#{name}"], [jid])
    end

    # Remove all jobs in the queue with the given class.
    # Accepts a String or Class but make sure to pass the fully
    # qualified Class name if you use a String.
    def delete_by_class(klass)
      raise ArgumentError, "No class name provided" unless klass
      Sidekiq::Pro::Scripting.call(:queue_delete_by_class, ["queue:#{name}"], [klass.to_s])
    end

    def unpause!
      Sidekiq.redis { |conn| conn.srem('paused', name) }
    end

    def pause!
      Sidekiq.redis { |conn| conn.sadd('paused', name) }
    end

    def paused?
      Sidekiq.redis { |conn| conn.sismember('paused', name) }
    end
  end

  class JobSet
    def find_job(jid)
      # When Sidekiq requires Ruby >= 2.0, we can conditionally extend this method using Module#prepend
      # instead of redefining it
      if Sidekiq.redis_version >= "2.6"
        result = Sidekiq::Pro::Scripting.call(:sorted_set_find_by_jid, [name], [jid])
        SortedEntry.new(self, result.last.to_f, result.first) if result
      else
        self.detect { |j| j.jid == jid }
      end
    end

    # Efficiently scan through a job set, returning any
    # jobs which contain the given substring.
    def scan(match, &block)
      regexp = "*#{match}*"
      Sidekiq.redis do |conn|
        if block_given?
          conn.zscan_each(name, :match => regexp) do |entry, score|
            yield SortedEntry.new(self, score, entry)
          end
        else
          conn.zscan_each(name, :match => regexp).map do |entry, score|
            SortedEntry.new(self, score, entry)
          end
        end
      end
    rescue Redis::CommandError => ex
      if ex.message =~ /unknown command/
        raise "Redis 2.8 is required for ZSCAN, please upgrade [#{Sidekiq.redis_version}]"
      else
        raise
      end
    end

  end
end
