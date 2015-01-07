require 'sidekiq/worker'

module Sidekiq
  module Worker
    attr_accessor :bid

    def batch
      Sidekiq::Batch.new(bid) if bid
    end
  end
end
