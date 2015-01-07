require 'helper'
require 'sidekiq/rack/batch_status'
require 'rack/test'

class TestStatusEndpoint < Minitest::Test
  describe 'batch_status' do
    include Rack::Test::Methods

    def app
      Sidekiq::Rack::BatchStatus.new(Sidekiq::Web)
    end

    class WebWorker
      include Sidekiq::Worker
    end

    after do
      Sidekiq::Queue.new.clear
    end

    before do
      Sidekiq.client_middleware do |chain|
        chain.add Sidekiq::Middleware::Client::Batch
      end
    end

    it 'handles bad urls' do
      get '/batch_status/123.json'
      assert_equal 404, last_response.status
    end

    it 'returns valid batch JSON' do
      b1 = Sidekiq::Batch.new
      b1.description = 'something big!'
      b1.jobs do
        3.times { WebWorker.perform_async(1,1) }
      end
      b2 = Sidekiq::Batch.new
      b2.jobs do
        5.times { WebWorker.perform_async(2,1) }
      end
      get "/batch_status/#{b1.bid}.json"
      assert_equal 200, last_response.status
      assert_equal 'application/json', last_response.content_type
      data = Sidekiq.load_json(last_response.body)
      assert_equal 3, data['total']
      assert_equal 3, data['pending']
      assert_equal b1.bid, data['bid']

      get "/batch_status/#{b2.bid}.json"
      assert_equal 200, last_response.status
      assert_equal 'application/json', last_response.content_type
      data = Sidekiq.load_json(last_response.body)
      assert_equal 5, data['total']
      assert_equal 5, data['pending']
      assert_equal b2.bid, data['bid']
    end

  end
end
