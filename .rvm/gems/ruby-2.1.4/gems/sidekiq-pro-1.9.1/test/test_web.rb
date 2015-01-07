require 'helper'
require 'sidekiq/web'
require 'sidekiq/pro/web'
require 'rack/test'

class TestWeb < Minitest::Test
  describe 'sidekiq-pro web' do
    include Rack::Test::Methods

    def app
      Sidekiq::Web
    end

    class WebWorker
      include Sidekiq::Worker

      def perform(a, b)
        a + b
      end
    end

    it 'can display home' do
      get '/'
      assert_equal 200, last_response.status
      assert_match /status-idle/, last_response.body
      assert_match /Batches/, last_response.body
    end

    it 'can display batches' do
      b1 = Sidekiq::Batch.new
      b1.description = 'something big!'
      b1.jobs do
        3.times { WebWorker.perform_async(1,1) }
      end
      b2 = Sidekiq::Batch.new
      b2.jobs do
        5.times { WebWorker.perform_async(2,1) }
      end
      get '/batches'
      assert_equal 200, last_response.status
      assert_match /#{b1.bid}/, last_response.body
      assert_match /#{b2.bid}/, last_response.body
      assert_match /something big/, last_response.body
    end

    it 'can display a specific batch' do
      b1 = Sidekiq::Batch.new
      b1.description = 'something big!'
      b1.jobs do
        3.times { WebWorker.perform_async(1,1) }
      end
      add_failure(b1.bid)
      get "/batches/#{b1.bid}"
      assert_equal 200, last_response.status
      assert_match /Batch #{b1.bid}/, last_response.body
      assert_match /RuntimeError/, last_response.body
      assert_match /Invalid/, last_response.body
      assert_match /something big/, last_response.body
    end

    def add_failure(bid)
      backtrace = [
        '/usr/local/foo/bar/baz.rb:23',
        '/usr/local/foo/bar/app/models/baz.rb:23',
        '/usr/local/foo/bar/app/controllers/admin/zzzzzzzzzzzzzzzzzz/yyyyyyyyyyyyyyyyy/xxxxxxxxxxxxx/baz.rb:23',
        '/usr/local/foo/bar/baz.rb:23',
      ]
      Sidekiq.redis do |conn|
        conn.hmset("b-#{bid}-failinfo",
                   Time.now.to_i,
                   Sidekiq.dump_json(['RuntimeError', "Invalid parameter count (2 for 0)", backtrace]))
      end
    end

    it 'can filter jobs' do
      jid1 = WebWorker.perform_in(5, 'bob', 'tammy')
      jid2 = WebWorker.perform_in(5, 'mike', 'jim')

      get '/scheduled'
      assert_equal 200, last_response.status
      assert_match /#{jid1}/, last_response.body
      assert_match /#{jid2}/, last_response.body

      post '/filter/scheduled', :substr => 'tammy'
      assert_equal 200, last_response.status
      assert_match /#{jid1}/, last_response.body
      refute_match /#{jid2}/, last_response.body

      get '/filter/scheduled'
      assert_equal 302, last_response.status
      get '/filter/retries'
      assert_equal 302, last_response.status
      get '/filter/dead'
      assert_equal 302, last_response.status
    end

  end
end
