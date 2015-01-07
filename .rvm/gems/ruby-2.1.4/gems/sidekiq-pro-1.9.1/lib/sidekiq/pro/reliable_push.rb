require 'thread'

module Sidekiq
  # Reliable push is designed to handle transient network failures,
  # which cause the client to fail to deliver jobs to Redis.  It is not
  # designed to be a perfectly reliable client but rather an incremental
  # improvement over the existing client which will just fail in the face
  # of any networking error.
  #
  # Each client process has a local queue, used for storage if a network problem
  # is detected.  Jobs are pushed to that queue if normal delivery fails.  If
  # normal delivery succeeds, the local queue is drained of any stored jobs.
  #
  # The standard `Sidekiq::Client.push` API returns a JID if the push to redis succeeded
  # and falsy if the push failed.  With this extension, push will return the JID as long
  # as the job was enqueued locally.
  #


  # backup_limit controls the total number of pushes which will be enqueued
  # before the client will start throwing away jobs.  Note this limit is per-process.
  # Note also that a bulk push is considered one push but might contain 100s or 1000s
  # of jobs.
  options[:backup_limit] = 1_000

  class Client
    @@local_queue = ::Queue.new

    def local_queue
      @@local_queue
    end

    def raw_push_with_backup(payloads)
      push_initial(payloads) do
        drain if !local_queue.empty?
      end
    end

    # Return true if we saved the payloads without error.
    # Yield if there was no exception.
    def push_initial(payloads)
      begin
        raw_push_without_backup(payloads)
        yield
      rescue => ex
        save_locally(payloads, ex)
      end
      true
    end

    def drain
      begin
        ::Sidekiq.logger.info("[ReliablePush] Connectivity restored, draining local queue")
        while !local_queue.empty?
          payloads = local_queue.pop(true)
          raw_push_without_backup(payloads)
          payloads = nil
        end
      rescue => ex
        save_locally(payloads, ex) if payloads
      end
    end

    def save_locally(payloads, ex)
      sz = local_queue.size
      if sz > ::Sidekiq.options[:backup_limit]
        ::Sidekiq.logger.error("[ReliablePush] Reached job backup limit, discarding job due to error: #{ex.message}")
        false
      else
        ::Sidekiq.logger.warn("[ReliablePush] Enqueueing job locally due to error: #{ex.message}") if sz == 0
        local_queue << payloads
        payloads
      end
    end

    ::Sidekiq.logger.debug("ReliablePush activated")
    alias_method :raw_push_without_backup, :raw_push
    alias_method :raw_push, :raw_push_with_backup
  end
end
