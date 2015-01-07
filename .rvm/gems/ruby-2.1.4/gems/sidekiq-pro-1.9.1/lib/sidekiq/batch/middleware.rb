require 'sidekiq/batch/lifecycle'

module Sidekiq
  module Middleware
    module Client
      class Batch

        def call(worker_class, msg, queue, redis_pool)
          batch = Thread.current[:sidekiq_batch]
          if batch
            msg['bid'] = batch.bid
            batch.register(msg['jid'])
          end
          yield
        end

      end
    end

    module Server
      class Batch

        def call(worker, msg, queue)
          worker.bid = bid = msg['bid']
          begin
            yield
            add_success(bid, msg['jid'], queue) if bid
          rescue Exception => e
            add_failure(bid, msg['jid'], queue, e) if bid
            raise
          end
        end

        private

        def add_success(bid, jid, queue)
          pending, _, failures = Sidekiq.redis do |conn|
            conn.multi do
              conn.decr("b-#{bid}-pending")
              conn.hdel("b-#{bid}-failinfo", jid)
              conn.hlen("b-#{bid}-failinfo")
              conn.publish("batch-#{bid}", '+')
            end
          end
          complete(bid, queue) if pending.to_i == failures.to_i && needs_notification?(bid)
          success(bid, queue) if pending.to_i == 0
        end

        def needs_notification?(bid)
          lock, _ = Sidekiq.redis do |conn|
            conn.multi do
              conn.setnx("b-#{bid}-notify", '1')
              conn.expire("b-#{bid}-notify", 60 * 60 * 24 * 7)
            end
          end
          lock
        end

        def complete(bid, queue)
          Sidekiq.redis do |conn|
            conn.publish("batch-#{bid}", '!')
          end
          Sidekiq::Client.push('class' => Sidekiq::Batch::Lifecycle,
                               'queue' => queue,
                               'args' => ['complete', bid])
        end

        def success(bid, queue)
          Sidekiq::Client.push('class' => Sidekiq::Batch::Lifecycle,
                               'queue' => queue,
                               'args' => ['success', bid])
          Sidekiq.redis do |conn|
            conn.multi do
              conn.publish("batch-#{bid}", '$')
              conn.zrem('batches', bid)
            end
          end
        end

        def add_failure(bid, jid, queue, ex)
          msg = Sidekiq.redis do |conn|
            conn.get("b-#{bid}")
          end
          return unless msg
          props = Sidekiq.load_json(msg)
          expiry = props['expiry'] || Sidekiq::Batch::EXPIRY

          info = Sidekiq.dump_json([ex.class.name, ex.message, ex.backtrace])
          _, _, pending, failures = Sidekiq.redis do |conn|
            conn.multi do
              conn.hset("b-#{bid}-failinfo", jid, info)
              conn.expire("b-#{bid}-failinfo", expiry)
              conn.get("b-#{bid}-pending")
              conn.hlen("b-#{bid}-failinfo")
              conn.publish("batch-#{bid}", '-')
            end
          end
          complete(bid, queue) if pending.to_i == failures.to_i && needs_notification?(bid)
        end

      end
    end

  end
end

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::Batch
  end
end
Sidekiq.configure_server do |config|
  config.client_middleware do |chain|
    chain.add Sidekiq::Middleware::Client::Batch
  end
  config.server_middleware do |chain|
    chain.add Sidekiq::Middleware::Server::Batch
  end
end
