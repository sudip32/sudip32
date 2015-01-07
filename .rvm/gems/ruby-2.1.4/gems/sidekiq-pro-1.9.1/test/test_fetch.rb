require 'helper'
require 'sidekiq/pro/reliable_fetch'

class TestFetch < Minitest::Spec

  before do
    Sidekiq.redis do |conn|
      conn.flushdb
    end
  end

  it 'raises an error with no index option' do
    assert_raises ArgumentError, /index option/ do
      Sidekiq::Pro::ReliableFetch.new(:queues => ['basic'])
    end
  end

  def hostname
    Socket.gethostname
  end

  it 'polls for paused queues' do
    Sidekiq.redis { |conn| conn.sadd('paused', 'default') }

    mock = Minitest::Mock.new
    mock.expect(:paused=, [], [Array])
    pp = Sidekiq::Pro::ReliableFetch::PausePoller.new(mock)
    pp.check
    mock.verify
  end

  it 'supports basic fetch, acknowledgment and requeueing' do
    Sidekiq.redis {|conn| conn.lpush('queue:basic', 'msg') }
    q = Sidekiq::Queue.new('basic')
    assert_equal 1, q.size
    q1 = Sidekiq::Queue.new("basic_#{hostname}_1")
    assert_equal 0, q1.size

    fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['basic'], :index => 1)
    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'msg', uow.message
    assert_equal 0, q.size
    assert_equal 1, q1.size

    assert_nil uow.requeue
    assert_equal 0, q.size
    assert_equal 1, q1.size

    assert_equal 1, uow.acknowledge
    assert_equal 0, q.size
    assert_equal 0, q1.size
  end

  it 'blocks on the first queue if no jobs are found when searching all queues' do
    fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['a', 'b'], :index => 1, :fetch_timeout => 1)
    Thread.new do
      sleep(0.05)
      Sidekiq.redis {|conn| conn.lpush('queue:a', 'msg') }
    end
    uow = fetch.retrieve_work
    assert_equal 'a', uow.queue_name
    assert_equal 'msg', uow.message
  end

  it 'replays existing messages first' do
    Sidekiq.redis do |conn|
      conn.lpush('queue:basic', 'msg')
      conn.lpush("queue:basic_#{hostname}_1", 'existing1')
      conn.lpush("queue:basic_#{hostname}_1", 'existing2')
    end
    q = Sidekiq::Queue.new('basic')
    assert_equal 1, q.size
    q1 = Sidekiq::Queue.new("basic_#{hostname}_1")
    assert_equal 2, q1.size

    fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['basic'], :index => 1)
    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'existing1', uow.message
    assert_equal 1, q.size
    assert_equal 2, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 1, q.size
    assert_equal 1, q1.size

    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'existing2', uow.message
    assert_equal 1, q.size
    assert_equal 1, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 1, q.size
    assert_equal 0, q1.size

    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'msg', uow.message
    assert_equal 0, q.size
    assert_equal 1, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 0, q.size
    assert_equal 0, q1.size
  end

  it 'replays messages in multiple queues' do
    Sidekiq.redis do |conn|
      conn.lpush('queue:basic', 'msg')
      conn.lpush("queue:basic_#{hostname}_1", 'existing1')
      conn.lpush("queue:basic_#{hostname}_1", 'existing2')
      conn.lpush("queue:multiple_#{hostname}_1", 'existing1')
      conn.lpush("queue:multiple_#{hostname}_1", 'existing2')
    end
    q = Sidekiq::Queue.new('basic')
    assert_equal 1, q.size
    q1 = Sidekiq::Queue.new("basic_#{hostname}_1")
    assert_equal 2, q1.size

    fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['basic', 'multiple'], :index => 1)
    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'existing1', uow.message
    assert_equal 1, q.size
    assert_equal 2, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 1, q.size
    assert_equal 1, q1.size

    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'existing2', uow.message
    assert_equal 1, q.size
    assert_equal 1, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 1, q.size
    assert_equal 0, q1.size

    uow = fetch.retrieve_work
    assert_equal 'multiple', uow.queue_name
    assert_equal 'existing1', uow.message
    assert_equal 1, uow.acknowledge

    uow = fetch.retrieve_work
    assert_equal 'multiple', uow.queue_name
    assert_equal 'existing2', uow.message
    assert_equal 1, uow.acknowledge

    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'msg', uow.message
    assert_equal 0, q.size
    assert_equal 1, q1.size
    assert_equal 1, uow.acknowledge
    assert_equal 0, q.size
    assert_equal 0, q1.size
  end


  describe 'strict ordering' do
    it 'draws from higher priority queues first' do
      Sidekiq.redis do |conn|
        conn.lpush('queue:basic', 'msg1')
        conn.lpush('queue:multiple', 'msg2')
        conn.lpush('queue:multiple', 'msg3')
        conn.lpush('queue:basic', 'msg4')
      end
      fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['basic', 'multiple'], :index => 1, :fetch_timeout => 0.1)
      uow = fetch.retrieve_work
      assert_equal 'msg1', uow.message
      uow = fetch.retrieve_work
      assert_equal 'msg4', uow.message
      uow = fetch.retrieve_work
      assert_equal 'msg2', uow.message
      uow = fetch.retrieve_work
      assert_equal 'msg3', uow.message
    end
  end

  describe 'weighted ordering' do
    it 'uses weighted random choice to select from queues' do
      low = Sidekiq::Queue.new('low')
      high = Sidekiq::Queue.new('high')

      Sidekiq.redis do |conn|
        5.times { conn.lpush('queue:low', 'low_msg') }
        10.times { conn.lpush('queue:high', 'high_msg') }
      end

      fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['high', 'high', 'low'], :index => 1, :fetch_timeout => 0.1)

      # Grab work 10 times, some of those should be for the low queue
      10.times { fetch.retrieve_work }

      refute_equal 5, low.size
      refute_equal 0, high.size
    end
  end

  it 'retrieves messages from multiple queues' do
    Sidekiq.redis do |conn|
      conn.lpush('queue:basic', 'msg1')
      conn.lpush('queue:multiple', 'msg2')
      conn.lpush('queue:multiple', 'msg3')
    end
    fetch = Sidekiq::Pro::ReliableFetch.new(:queues => ['basic', 'multiple'], :index => 1, :fetch_timeout => 1)
    uow = fetch.retrieve_work
    assert_equal 'basic', uow.queue_name
    assert_equal 'msg1', uow.message
    uow = fetch.retrieve_work
    assert_equal 'multiple', uow.queue_name
    assert_equal 'msg2', uow.message
    uow = fetch.retrieve_work
    assert_equal 'multiple', uow.queue_name
    assert_equal 'msg3', uow.message

    # nothing left, empty queues!
    uow = fetch.retrieve_work
    refute uow
  end

  describe 'bulk requeue' do
    it 'moves all the work back from the internal queues' do
      Sidekiq.redis do |conn|
        conn.lpush("queue:basic_#{hostname}_1", 'existing1')
        conn.lpush("queue:basic_#{hostname}_1", 'existing2')
      end
      q = Sidekiq::Queue.new('basic')
      assert_equal 0, q.size
      q1 = Sidekiq::Queue.new("basic_#{hostname}_1")
      assert_equal 2, q1.size

      Sidekiq::Pro::ReliableFetch.bulk_requeue([], {:queues => ["basic"], :index => 1})

      assert_equal 2, q.size
      assert_equal 0, q1.size
    end
  end
end
