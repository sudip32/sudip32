require 'helper'
require 'pony'

class TestEmail < Minitest::Test
  def test_happy_path
    mock = Minitest::Mock.new
    mock.expect(:mail, nil, [Hash])

    stat = success_status
    c = Sidekiq::Notifications::Email.new(mock)
    email = c.on_complete(stat, :to => 'mike@perham.net')
    stat.verify

    assert_match /Success/, email[:html_body]
    assert_equal 'mike@perham.net', email[:to]
    refute_match /Failures/, email[:html_body]
  end

  def test_with_failures
    mock = Minitest::Mock.new
    mock.expect(:mail, nil, [Hash])

    stat = failure_status
    c = Sidekiq::Notifications::Email.new(mock)
    email = c.on_complete(stat, 'to' => 'mike@perham.net', 'subject' => 'Uh oh, bummer man')
    stat.verify
    assert_match /Error/, email[:html_body]
    assert_match /Failures/, email[:html_body]
    assert_match /bummer/, email[:subject]
  end

  def success_status
    status = MiniTest::Mock.new
    status.expect(:pending, 0)
    status.expect(:pending, 0)
    status.expect(:pending, 0)
    status.expect(:bid, "123456")
    status.expect(:created_at, Time.now - 30)
    status.expect(:total, 50)
    status.expect(:total, 50)
    status.expect(:failure_info, [])
    status
  end

  def failure_status
    failure = MiniTest::Mock.new
    failure.expect(:jid, '98765')
    failure.expect(:error_class, 'RuntimeError')
    failure.expect(:error_message, 'Something went wrong here')
    failure.expect(:backtrace, [
      '/usr/local/foo/bar/baz.rb:23',
      '/usr/local/foo/bar/app/models/baz.rb:23',
      '/usr/local/foo/bar/app/controllers/admin/baz.rb:23',
      '/usr/local/foo/bar/baz.rb:23',
    ])

    status = MiniTest::Mock.new
    status.expect(:pending, 5)
    status.expect(:pending, 5)
    status.expect(:pending, 5)
    status.expect(:bid, "123456")
    status.expect(:bid, "123456")
    status.expect(:created_at, Time.now - 30)
    status.expect(:total, 50)
    status.expect(:total, 50)
    status.expect(:failure_info, [failure])
    status
  end
end
