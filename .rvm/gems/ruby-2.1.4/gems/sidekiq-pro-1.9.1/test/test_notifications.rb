require 'helper'

class TestNotifications < Minitest::Test
  class Worker
    include Sidekiq::Worker
  end

  PUBSUB = []
  PST = Thread.new do
    Sidekiq.redis do |conn|
      conn.psubscribe("batch-*") do |on|
        on.pmessage do |pattern, channel, msg|
          PUBSUB << msg
        end
      end
    end
  end

  describe 'notifications' do
    before do
      Sidekiq.client_middleware do |chain|
        chain.add Sidekiq::Middleware::Client::Batch
      end
    end

    it 'sends_complete_notification_when_done' do
      PUBSUB.clear
      $c = 0
      $s = 0
      with_batch(SuccessCallback) do |batch|
        Sidekiq::Testing.inline! do
          assert_equal 2, batch.callbacks.size
          ware = Sidekiq::Middleware::Server::Batch.new
          ware.call(Worker.new, { 'bid' => batch.bid, 'jid' => '1' }, 'default') {}
          ware.call(Worker.new, { 'bid' => batch.bid, 'jid' => '2' }, 'default') {}
          sleep 0.02 # race condition waiting for the pubsub array
          assert_equal %w(+ + ! $), PUBSUB
        end
      end
      assert_equal 1, $c
      assert_equal 1, $s
    end

    class SuccessCallback
      def on_complete(status, hash)
        $c = $c + 1
      end
      def on_success(status, hash)
        $s = $s + 1
      end
    end

    class CompleteCallback
      def on_complete(status, hash)
        $i = $i + 1
      end
    end

    it 'sends_complete_notification_even_with_failures' do
      PUBSUB.clear

      $i = 0
      with_batch(CompleteCallback) do |batch|
        Sidekiq::Testing.inline! do
          ware = Sidekiq::Middleware::Server::Batch.new
          assert_raises RuntimeError do
            ware.call(Worker.new, { 'bid' => batch.bid, 'jid' => '1' }, 'default') { raise "BOOM" }
          end
          assert_raises RuntimeError do
            ware.call(Worker.new, { 'bid' => batch.bid, 'jid' => '2' }, 'default') { raise "BOOM" }
          end
          assert_raises RuntimeError do
            ware.call(Worker.new, { 'bid' => batch.bid, 'jid' => '2' }, 'default') { raise "BOOM" }
          end
          sleep 0.02 # race condition waiting for the pubsub array
          assert_equal ['-', '-', '!', '-'], PUBSUB
        end
      end

      assert_equal 1, $i
    end

    def with_batch(callbacks)
      batch = Sidekiq::Batch.new
      batch.on(:success, callbacks)
      batch.on(:complete, callbacks)
      batch.jobs do
        Worker.perform_async
        Worker.perform_async
      end
      yield batch
    end
  end
end
