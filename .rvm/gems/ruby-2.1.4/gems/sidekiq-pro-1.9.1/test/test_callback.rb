require 'helper'
require 'pony'

class TestCallback < Minitest::Test
  class SomeNotification
    def on_complete(status, options)
      'complete'
    end
    def on_success(status, options)
      'on_success'
    end
    def cleanup(status, options)
      'cleanup'
    end
    def boom(status, options)
      raise 'oops'
    end
  end

  def test_basic_class
    stat = success_status
    c = Sidekiq::Notifications::Callback.new('complete', SomeNotification.to_s)
    assert_equal SomeNotification, c.klass
    assert_equal 'on_complete', c.method
    assert_equal 'complete', c.notify(stat)
    stat.verify
  end

  def test_with_custom_method
    stat = success_status
    c = Sidekiq::Notifications::Callback.new('complete', "#{SomeNotification.to_s}#cleanup")
    assert_equal SomeNotification, c.klass
    assert_equal 'cleanup', c.method
    assert_equal 'cleanup', c.notify(stat)
    stat.verify
  end

  def test_success
    stat = success_status
    c = Sidekiq::Notifications::Callback.new('success', "TestCallback::SomeNotification")
    assert_equal SomeNotification, c.klass
    assert_equal 'on_success', c.method
    assert_equal 'on_success', c.notify(stat)
    stat.verify
  end

  def success_status
    MiniTest::Mock.new
  end
end
