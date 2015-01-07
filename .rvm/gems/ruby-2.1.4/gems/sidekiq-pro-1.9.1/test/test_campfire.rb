require 'helper'

class TestCampfire < Minitest::Test
  def test_success
    stub_request(:post, "https://417:X@acmecorp.campfirenow.com/room/111111/speak.json").
      with(:body => "{\"message\":{\"body\":\"Success! Sidekiq finished batch 123456 in 30 seconds, 50 of 50 successfully. http://example.org/sidekiq/batches/123456\",\"type\":\"TextMessage\"}}",
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(:status => 201, :body => "", :headers => {})
    stat = success_status
    c = Sidekiq::Notifications::Campfire.new
    c.on_complete(stat, options)
    stat.verify
  end

  def test_failures
    stub_request(:post, "https://417:X@acmecorp.campfirenow.com/room/111111/speak.json").
      with(:body => "{\"message\":{\"body\":\"Sidekiq finished batch 123456 in 30 seconds, 45 of 50 successfully. http://example.org/sidekiq/batches/123456\",\"type\":\"TextMessage\"}}",
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(:status => 201, :body => "", :headers => {})
    stat = failure_status
    c = Sidekiq::Notifications::Campfire.new
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
    { subdomain: 'acmecorp', roomid: 111111, token: '417' }
  end
end
