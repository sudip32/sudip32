module Sidekiq
  module Notifications
    class Email
      attr_reader :options

      def initialize(provider=Pony)
        @provider = provider
      end

      def on_complete(status, opts)
        @options = Sidekiq.options[:notifications][:email].merge(opts.symbolize_keys)

        subject = "[sidekiq] Your work has finished"
        template = Tilt.new("#{File.dirname(__FILE__)}/templates/email.html.erb")
        body = template.render(self, :status => status, :subject => subject)
        email = { :subject => subject, :html_body => body }.merge(options)
        @provider.mail(email)
        email
      end

    end
  end
end
