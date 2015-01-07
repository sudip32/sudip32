require 'helper'

class TestReliablePush < Minitest::Test
  def setup
    Sidekiq.redis { |conn| conn.flushdb }
    require 'sidekiq/pro/reliable_push'
  end

  def teardown
    Sidekiq::Client.default.local_queue.clear
  end

  def test_handles_happy_path
    jid = Sidekiq::Client.push('class' => 'FooWorker', 'args' => [1,2,4])
    q = Sidekiq::Queue.new
    assert_equal 1, q.size
    job = q.to_a.first

    assert jid
    assert_equal 24, jid.size
    assert job
    assert_equal [1,2,4], job.args
    assert Sidekiq::Client.default.local_queue.empty?
  end

  def test_enqueues_locally_if_error
    Sidekiq::Client.default.stub(:raw_push_without_backup, lambda { |x| raise 'boom' }) do
      result = Sidekiq::Client.push('class' => 'FooWorker', 'args' => [1,2,4])
      refute Sidekiq::Client.default.local_queue.empty?
      assert result
      assert_equal 24, result.size
    end
  end

  def test_drains_for_all_client_instances
    c1 = Sidekiq::Client.new
    c1.stub(:raw_push_without_backup, lambda { |x| raise 'boom' }) do
      c1.push('class' => 'FooWorker', 'args' => [1,2,4])
      assert_equal 1, c1.local_queue.size
    end

    c2 = Sidekiq::Client.new
    c2.stub(:raw_push_without_backup, lambda { |x| raise 'boom' }) do
      c2.push('class' => 'FooWorker', 'args' => [1,2,5])
      assert_equal 2, c2.local_queue.size
    end

    q = Sidekiq::Queue.new
    assert_equal 0, q.size
    Sidekiq::Client.push('class' => 'FooWorker', 'args' => [1,2,7])
    assert_equal 3, q.size
  end

  def test_drains_local_queue_if_ok
    Sidekiq::Client.default.stub(:raw_push_without_backup, lambda { |x| raise 'boom' }) do
      Sidekiq::Client.push('class' => 'FooWorker', 'args' => [1,2,4])
      refute Sidekiq::Client.default.local_queue.empty?
    end

    q = Sidekiq::Queue.new
    assert_equal 0, q.size
    jid = Sidekiq::Client.push('class' => 'FooWorker', 'args' => [1,2,4])
    assert_equal 2, q.size
    assert jid
    assert_equal 24, jid.size
  end
end
