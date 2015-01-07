require 'helper'
require 'sidekiq/pro/expiry'

class TestExpiry < Minitest::Test
  describe 'middleware' do
    before do
      Sidekiq.client_middleware.clear
    end

    it 'does nothing with a normal job' do
      mid = Sidekiq::Middleware::Expiry::Server.new
      hit = 0
      mid.call(nil, {}, nil) do
        hit = 1
      end
      assert_equal 1, hit
    end

    it 'passes on unexpired jobs' do
      mid = Sidekiq::Middleware::Expiry::Server.new
      job = { 'expires_at' => Time.now.to_f + 1 }
      mid.call(nil, job, nil) {}
      refute_nil job['expires_at']
    end

    it 'expires scheduled jobs' do
      worker = Minitest::Mock.new
      worker.expect(:logger, Logger.new("/dev/null"), [])
      worker.expect(:jid, "123456", [])

      cli = Sidekiq::Middleware::Expiry::Client.new
      now = Time.now.to_f
      job = { 'at' => now + 1, 'expires_in' => 1 }
      cli.call(worker, job, nil, nil) {}
      assert_equal now + 2, job['expires_at']

      processed = false
      ser = Sidekiq::Middleware::Expiry::Server.new
      ser.call(worker, job, nil) do
        processed = true
      end
      refute_nil job['expires_at']
      assert processed
    end

    it 'expires jobs' do
      worker = Minitest::Mock.new
      worker.expect(:logger, Logger.new("/dev/null"), [])
      worker.expect(:jid, "123456", [])
      mid = Sidekiq::Middleware::Expiry::Server.new
      job = {}
      mid.call(worker, { 'expires_at' => Time.now.to_f - 1 }, nil) do |_, msg, _|
        job = msg
      end
      assert_nil job['expires_at']
    end
  end
end

