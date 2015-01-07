require 'net/http'
require 'cgi'
module Sidekiq
  module Notifications
    class Hipchat
      attr_reader :options

      ##
      # Paste a message into a Hipchat room when a job or batch
      # completes.
      #
      # Required options:
      #   token - your Hipchat API token (https://www.hipchat.com/admin/api)
      #   roomid - https://www.hipchat.com/admin/rooms
      def on_complete(status, opts)
        @options = Sidekiq.options[:notifications][:hipchat].merge(opts).stringify_keys
        say "#{status.pending == 0 ? 'Success! ' : ''}Sidekiq finished batch #{status.bid} in #{(Time.now - status.created_at).to_i} seconds, #{status.total - status.pending} of #{status.total} successfully. #{url(status)}"
      end

      private

      def url(status)
        "#{Sidekiq.options[:web]}/batches/#{status.bid}" if Sidekiq.options[:web]
      end

      ##
      # Broadcast a message to Hipchat from your Sidekiq worker.
      #
      #   hipchat.say("#{self.class.name} finished successfully!")
      #
      def say(msg)
        http = Net::HTTP.new("api.hipchat.com", 443)
        http.use_ssl = true
        request = Net::HTTP::Post.new("/v1/rooms/message?format=json&auth_token=#{options['token']}")
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        request.body = "room_id=#{options['roomid']}&from=Sidekiq&message=#{CGI.escape(msg)}&message_format=text"
        response = http.request(request)
        raise response.inspect if response.code != "200"
        msg
      end
    end

  end
end
