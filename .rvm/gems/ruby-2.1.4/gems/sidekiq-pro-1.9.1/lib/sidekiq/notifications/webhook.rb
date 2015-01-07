require 'uri'
require 'net/http'

module Sidekiq
  module Notifications
    class Webhook
      attr_reader :options

      ##
      # POST to a supplied URL when a Batch has completed.
      #
      # Required options:
      #   'url' - the URL to POST to.
      #
      # Optional options:
      #   'username' - username for Basic Auth
      #   'password' - password for Basic Auth
      def on_complete(status, opts)
        @options = Sidekiq.options[:notifications][:webhook].merge(opts).stringify_keys

        uri = URI(options['url'])
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')
        request = Net::HTTP::Post.new(uri.path)
        request['Content-Type'] = 'application/json'
        request.basic_auth(options['username'], options['password']) if options['username']
        request.body = status.to_json

        response = http.request(request)
        Sidekiq.logger.info("Unsuccessful webhook response code #{response.code} for #{options['url']}") if !response.is_a?(Net::HTTPSuccess)
        response
      end

    end
  end
end
