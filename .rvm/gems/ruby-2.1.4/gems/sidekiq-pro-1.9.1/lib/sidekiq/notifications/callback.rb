require 'sidekiq/exception_handler'

module Sidekiq
  module Notifications

    ##
    # Call a method on a class when a batch is complete.  This is not
    # a traditional callback because it is not called on any worker
    # instance.  Examples:
    #
    #     batch.on(:success, Foo)
    #
    # Just pass a class, will call <tt>Foo.new.on_success(status)</tt>.
    #
    #     batch.on(:complete, 'FooWorker#cleanup')
    #
    # Pass class#method, will call <tt>FooWorker.new.cleanup(status)</tt>.
    class Callback
      include Sidekiq::ExceptionHandler

      attr_reader :klass, :method

      def initialize(event, target)
        @target = target
        klass_name, method = @target.split('#')
        @klass = klass_name.constantize
        @method = method || "on_#{event}"
      end

      def notify(status, options={})
        @klass.new.send(@method, status, options)
      end
    end
  end
end
