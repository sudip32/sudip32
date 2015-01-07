require 'helper'

class TestWebhook < Minitest::Test
  def test_success
    stub_request(:post, "https://root:xyzzy@mike.acmecorp.com/foo/bar").
      with(:body => "{\"is_complete\":true,\"bid\":\"1f87ae422b1e\",\"total\":50,\"pending\":0,\"description\":null,\"failures\":0,\"created_at\":1238624459.0,\"fail_info\":[]}",
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
    stat = success_status
    c = Sidekiq::Notifications::Webhook.new
    c.on_complete(stat, options)
  end

  def test_failures
    stub_request(:post, "https://root:xyzzy@mike.acmecorp.com/foo/bar").
      with(:body => "{\"is_complete\":true,\"bid\":\"887f4eea1c92\",\"total\":50,\"pending\":2,\"description\":null,\"failures\":2,\"created_at\":1238624459.0,\"fail_info\":[{\"jid\":\"abcdef\",\"error_class\":\"RuntimeError\",\"error_message\":\"Something failed\",\"backtrace\":null},{\"jid\":\"187635\",\"error_class\":\"ArgumentError\",\"error_message\":\"Oops, failed\",\"backtrace\":null}]}",
           :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
      to_return(:status => 200, :body => "", :headers => {})
    stat = failure_status
    c = Sidekiq::Notifications::Webhook.new
    c.on_complete(stat, options)
  end

  private

  def success_status
    status = TestStatus.new
    status.pending = 0
    status.failures = 0
    status.bid = "1f87ae422b1e"
    status.created_at = Time.at(1238624459)
    status.total = 50
    status
  end

  def failure_status
    status = TestStatus.new
    status.pending = 2
    status.failures = 2
    status.bid = "887f4eea1c92"
    status.created_at = Time.at(1238624459)
    status.total = 50
    status.failure_info = [
      Sidekiq::Batch::Status::Failure.new('abcdef', 'RuntimeError', 'Something failed'),
      Sidekiq::Batch::Status::Failure.new('187635', 'ArgumentError', 'Oops, failed'),
    ]
    status
  end

  def options
    { url: 'https://mike.acmecorp.com/foo/bar', username: 'root', password: 'xyzzy' }
  end

  class TestStatus < Sidekiq::Batch::Status
    attr_accessor :bid, :total, :pending, :failures, :created_at, :notifications, :failure_info

    def initialize
      @failure_info = []
    end
  end
end
