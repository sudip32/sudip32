require 'helper'
require 'sidekiq/pro/scripting'
require 'sidekiq/pro/api'

class TestApi < Minitest::Spec
  class ScriptWorker
    include Sidekiq::Worker
  end
  class ScriptWorker2
    include Sidekiq::Worker
  end

  before do
    Sidekiq::Queue.new.clear
  end

  it 'provides delete by jid' do
    q = Sidekiq::Queue.new
    q.clear

    jid1 = ScriptWorker.perform_async(1)
    jid2 = ScriptWorker.perform_async(1)

    assert_equal 2, q.size
    assert jid1
    assert jid2

    result = q.delete_job(jid2)

    assert result
    assert_equal 1, q.size
    assert q.delete_job(jid1)
    assert_equal 0, q.size
    refute q.delete_job('noexist')
  end

  describe 'find job by jid' do
    it 'can find a job by jid' do
      timestamp = Time.now.to_i + 100
      jid = ScriptWorker.perform_at(timestamp)
      set = Sidekiq::ScheduledSet.new
      job = set.find_job(jid)
      assert_equal job.score, timestamp
      assert_equal job.jid, jid
    end

    it 'returns nil if no job is found' do
      set = Sidekiq::ScheduledSet.new
      job = set.find_job("foo")
      assert_nil job
    end
  end

  describe 'delete by class' do
    it 'works' do
      ScriptWorker.perform_async
      ScriptWorker2.perform_async
      ScriptWorker.perform_async

      q = Sidekiq::Queue.new
      assert_equal 3, q.size

      # parent module won't work
      assert_equal 0, q.delete_by_class(TestApi)

      # class reference will resolve to the full name
      assert_equal 2, q.delete_by_class(ScriptWorker)
      assert_equal 1, q.size

      # strings need the full class name
      assert_equal 0, q.delete_by_class("ScriptWorker2")
      assert_equal 1, q.delete_by_class("TestApi::ScriptWorker2")

      assert_equal 0, q.size
    end

    it 'works with multiple pages' do
      60.times do
        ScriptWorker2.perform_async
        ScriptWorker.perform_async
      end

      q = Sidekiq::Queue.new
      assert_equal 120, q.size
      assert_equal 60, q.delete_by_class(ScriptWorker)
      assert_equal 60, q.size
      assert_equal 60, q.delete_by_class(ScriptWorker2)
      assert_equal 0, q.size
    end
  end

  describe 'pausing' do
    it 'has a bunch of pause APIs' do
      q = Sidekiq::Queue.new('foo')
      refute q.paused?
      assert_equal true, q.pause!
      assert q.paused?
      assert_equal true, q.unpause!
      refute q.paused?
    end
  end

  describe 'scan' do
    it 'scans' do
      set = Sidekiq::ScheduledSet.new
      set.clear

      ScriptWorker2.perform_in(10)
      ScriptWorker.perform_in(10)

      begin
        count = 0
        set.scan('Worker2') do |job|
          count += 1
        end
        assert_equal 1, count

        results = set.scan('Worker2')
        assert_equal 1, results.size
        job = results.first
        assert_equal 'TestApi::ScriptWorker2', job.klass
      rescue RuntimeError
        puts "Skipping Redis 2.8+ test"
      end
    end
  end
end
