require 'helper'

class TestHipchat < Minitest::Test
  def test_success
    stub_request(:post, "https://api.hipchat.com/v1/rooms/message?auth_token=417&format=json").
      with(:body => {"from"=>"Sidekiq", "message"=>"Success! Sidekiq finished batch 123456 in 30 seconds, 50 of 50 successfully. http://example.org/sidekiq/batches/123456", "message_format"=>"text", "room_id"=>"Development"},
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})

    stat = success_status
    c = Sidekiq::Notifications::Hipchat.new
    c.on_complete(stat, options)
    stat.verify
  end

  def test_failures
    stub_request(:post, "https://api.hipchat.com/v1/rooms/message?auth_token=417&format=json").
      with(:body => {"from"=>"Sidekiq", "message"=>"Sidekiq finished batch 123456 in 30 seconds, 45 of 50 successfully. http://example.org/sidekiq/batches/123456", "message_format"=>"text", "room_id"=>"Development"},
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
    stat = failure_status
    c = Sidekiq::Notifications::Hipchat.new
    c.on_complete(stat, options)
    stat.verify
  end

  private

  def success_status
    status = MiniTest::Mock.new
    status.expect(:pending, 0)
    status.expect(:pending, 0)
    status.expect(:pending, 0)
    status.expect(:bid, "123456")
    status.expect(:bid, "123456")
    status.expect(:created_at, Time.now - 30)
    status.expect(:total, 50)
    status.expect(:total, 50)
    status
  end

  def failure_status
    status = MiniTest::Mock.new
    status.expect(:pending, 5)
    status.expect(:pending, 5)
    status.expect(:pending, 5)
    status.expect(:bid, "123456")
    status.expect(:bid, "123456")
    status.expect(:created_at, Time.now - 30)
    status.expect(:total, 50)
    status.expect(:total, 50)
    status
  end

  def options
    { roomid: 'Development', token: '417' }
  end
end
