module Sidekiq
  class Batch
    class Lifecycle
      include Sidekiq::Worker

      def perform(event, bid)
        @status = Status.new(bid)
        fire!(event) if @status
      end

      def complete!
        fire!('complete')
      end

      def success!
        fire!('success')
      end

      private

      def callbacks
        @status.callbacks
      end

      def fire!(event)
        return unless callbacks[event]
        callbacks[event].each do |hash|
          hash.each_pair do |target, options|
            Sidekiq::Notifications::Callback.new(event, target).notify(@status, options)
          end
        end
      end

    end
  end
end
