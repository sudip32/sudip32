require 'helper'

class TestBatch < Minitest::Test

  def setup
    Sidekiq.instance_variable_set(:@client_chain, Sidekiq::Middleware::Chain.new)
    Sidekiq.client_middleware.add Sidekiq::Middleware::Client::Batch
  end

  def teardown
    Sidekiq.redis {|conn| conn.flushdb }
  end

  class SomeWorker
    include Sidekiq::Worker
    def perform
    end
  end

  def test_batch
    Sidekiq.configure_client do |config|
      config.client_middleware do |chain|
        chain.add Sidekiq::Middleware::Client::Batch
      end
    end
    batch = Sidekiq::Batch.new
    batch.description = 'something else'
    batch.expires_in 10*24*60*60
    batch.notify(:campfire, :foo => 'bar')
    assert batch.mutable?
    jids = batch.jobs do
      5.times do
        SomeWorker.perform_async
      end
    end
    assert !batch.mutable?
    assert_equal 5, jids.size
    assert_raises RuntimeError do
      batch.notify(:naughty)
    end

    assert_equal 864000, batch.expiry
    assert_equal 5, batch.status.total
    assert batch.created_at
    assert batch.bid
    assert_equal jids.sort, batch.jids.sort

    assert_equal 2, batch.invalidate_jids(jids[0], jids[1])
    assert_equal 3, batch.jids.size
    assert batch.include?(jids[2])
    refute batch.include?(jids[0])

    result = batch.status
    assert_equal batch.bid, result.bid
    assert_equal 5, result.total
    assert_equal 5, result.pending
    assert_equal 0, result.failures
    assert_equal 'something else', result.description
    refute result.complete?
    assert_equal 'bar', result.callbacks["complete"].first["Sidekiq::Notifications::Campfire"]["foo"]
    assert_equal 3, result.jids.size
    refute result.include?(jids[0])

    assert_equal 1, batch.invalidate_all
    assert_equal 0, result.jids.size

    assert_equal batch.bid, result.delete
    assert_raises Sidekiq::Batch::NoSuchBatch do
      batch.status
    end
  end

  def test_atomic_batches
    q = Sidekiq::Queue.new
    assert_equal 0, q.size

    batch = Sidekiq::Batch.new
    begin
      batch.jobs do
        SomeWorker.perform_async
        SomeWorker.perform_async
        raise "kerboom"
      end
    rescue RuntimeError
      assert_equal 0, q.size
    end
  end

  def test_mutable_batches
    Sidekiq.configure_client do |config|
      config.client_middleware do |chain|
        chain.add Sidekiq::Middleware::Client::Batch
      end
    end
    batch = Sidekiq::Batch.new
    batch.notify(:campfire, :foo => 'bar')
    oldjids = batch.jobs do
      5.times do
        SomeWorker.perform_async
      end
    end

    assert_equal 5, batch.status.total
    batch = Sidekiq::Batch.new(batch.bid)
    assert_raises RuntimeError do
      batch.notify(:email)
    end
    newjids = batch.jobs do
      5.times do
        SomeWorker.perform_async
      end
    end
    refute_equal newjids, oldjids
    assert_equal [], newjids & oldjids
    assert_equal (oldjids + newjids).sort, batch.jids.sort
    assert_equal 10, batch.status.total
  end

  class BatchBatchWorker
    include Sidekiq::Worker
    def perform
      # verify batch accessor
      raise "BOOM" if batch.jids.size <= 0

      b = Sidekiq::Batch.new(bid)
      b.jobs do
        SomeWorker.perform_async
      end
    end

    def on_success(status, options)
      $success += 1
    end
    def on_complete(status, options)
      $complete += 1
    end
  end

  def test_batch_invalid_callback
    b = Sidekiq::Batch.new
    assert_raises ArgumentError, /garbage/ do
      b.on(:garbage, BatchBatchWorker)
    end
  end

  def test_batch_callbacks
    $complete = $success = 0

    b = Sidekiq::Batch.new
    b.on(:success, BatchBatchWorker)
    b.on(:complete, BatchBatchWorker)
    bid = b.bid
    b.jobs do
      BatchBatchWorker.perform_async
    end

    assert_equal 2, b.callbacks.size

    bbw = BatchBatchWorker.new
    msg = { 'jid' => SecureRandom.hex(12), 'bid' => bid, 'class' => 'BatchBatchWorker', 'args' => [] }
    Sidekiq.instance_variable_set(:@server_chain, Sidekiq::Middleware::Chain.new)
    Sidekiq.server_middleware.add Sidekiq::Middleware::Server::Batch
    Sidekiq::Testing.inline! do
      Sidekiq.server_middleware.invoke(bbw, msg, 'default') do
        bbw.perform(*msg['args'])
      end
    end

    assert_equal 0, $complete
    assert_equal 0, $success
    assert_raises RuntimeError do
      Sidekiq::Testing.inline! do
        Sidekiq.server_middleware.invoke(bbw, msg, 'default') do
          raise "boom"
        end
      end
    end
    assert_equal 1, $complete
    assert_equal 0, $success
    Sidekiq::Testing.inline! do
      Sidekiq.server_middleware.invoke(bbw, msg, 'default') do
        SomeWorker.new.perform
      end
    end
    assert_equal 1, $complete
    assert_equal 1, $success
  end

  def test_batches_can_modify_themselves
    s = Sidekiq::Queue.new
    assert_equal 0, s.size

    b = Sidekiq::Batch.new
    bid = b.bid
    b.jobs do
      BatchBatchWorker.perform_async
    end

    s = Sidekiq::Queue.new
    assert_equal 16, bid.size
    assert_equal 1, s.size
    status1 = Sidekiq::Batch::Status.new(bid)
    assert_equal 1, status1.total
    assert_equal 1, status1.pending

    bbw = BatchBatchWorker.new
    msg = { 'jid' => SecureRandom.hex(12), 'bid' => bid, 'class' => 'BatchBatchWorker', 'args' => [] }
    Sidekiq.instance_variable_set(:@server_chain, Sidekiq::Middleware::Chain.new)
    Sidekiq.server_middleware.add Sidekiq::Middleware::Server::Batch
    Sidekiq.server_middleware.invoke(bbw, msg, 'default') do
      bbw.perform(*msg['args'])
    end

    assert_equal 2, s.size
    status2 = Sidekiq::Batch::Status.new(bid)
    assert_equal 2, status2.total
    assert_equal 1, status2.pending
    assert_equal status2.description, status1.description
    assert_equal status2.created_at, status1.created_at
    assert_equal status2.callbacks, status1.callbacks
    assert_equal Sidekiq::Batch::EXPIRY, status2.expiry
  end

end
