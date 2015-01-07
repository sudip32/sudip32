require 'net/http'

module Sidekiq
  module Notifications
    class Campfire
      attr_reader :options

      ##
      # Paste a message into a Campfire room when a job or batch
      # completes.
      #
      # Required options:
      #   token - your Campfire API token
      #   subdomain - https://[subdomain].campfirenow.com/room/[roomid]
      #   roomid - https://[subdomain].campfirenow.com/room/[roomid]
      def on_complete(status, opts)
        @options = Sidekiq.options[:notifications][:campfire].merge(opts).stringify_keys
        say "#{status.pending == 0 ? 'Success! ' : ''}Sidekiq finished batch #{status.bid} in #{(Time.now - status.created_at).to_i} seconds, #{status.total - status.pending} of #{status.total} successfully. #{url(status)}"
      end

      private

      def url(status)
        "#{Sidekiq.options[:web]}/batches/#{status.bid}" if Sidekiq.options[:web]
      end

      ##
      # Broadcast a message to Campfire from your Sidekiq worker.
      #
      #   campfire.say("#{self.class.name} finished successfully!")
      #   campfire.say("trombone", :Sound)
      #
      def say(msg, type=:Text)
        http = Net::HTTP.new("#{options['subdomain']}.campfirenow.com", 443)
        http.use_ssl = true
        request = Net::HTTP::Post.new("/room/#{options['roomid']}/speak.json")
        request['Content-Type'] = 'application/json'
        request.basic_auth options['token'], 'X'
        request.body = Sidekiq.dump_json({:message => {:body => msg, :type => "#{type}Message"}})

        response = http.request(request)
        raise response.inspect if response.code != "201"
        msg
      end
    end

  end
end
