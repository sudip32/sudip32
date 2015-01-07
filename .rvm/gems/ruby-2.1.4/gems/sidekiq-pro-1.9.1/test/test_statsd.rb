require 'helper'
require 'sidekiq/middleware/server/statsd'

class TestStatsd < Minitest::Test

  class FakeStatsd
    attr_accessor :incs, :times
    def increment(name)
      (@incs ||= []) << name
    end
    def time(name, &block)
      (@times ||= []) << name
      block.call
    end
  end

  describe 'middleware' do
    it 'handles success' do
      statsd = FakeStatsd.new
      mid = Sidekiq::Middleware::Server::Statsd.new(:client => statsd)
      mid.call(nil, nil, nil) do
        # nothing
      end
      assert_equal ["jobs.count", "jobs.NilClass.count", "jobs.success", "jobs.NilClass.success"], statsd.incs
      assert_equal ["jobs.NilClass.perform"], statsd.times
    end

    it 'handles failure' do
      statsd = FakeStatsd.new
      mid = Sidekiq::Middleware::Server::Statsd.new(:client => statsd)
      assert_raises RuntimeError do
        mid.call(nil, nil, nil) do
          raise "boom"
        end
      end
      assert_equal ["jobs.count", "jobs.NilClass.count", "jobs.failure", "jobs.NilClass.failure"], statsd.incs
      assert_equal ["jobs.NilClass.perform"], statsd.times
    end
  end
end

