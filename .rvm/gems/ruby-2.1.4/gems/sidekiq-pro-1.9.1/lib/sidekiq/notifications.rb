require 'sidekiq/notifications/webhook'
require 'sidekiq/notifications/campfire'
require 'sidekiq/notifications/hipchat'
require 'sidekiq/notifications/email'
require 'sidekiq/notifications/callback'

module Sidekiq
  module Notifications

    AVAILABLE = {
      :email => Email,
      :campfire => Campfire,
      :webhook => Webhook,
      :callback => Callback,
      :hipchat => Hipchat
    }

    def self.get(sym)
      AVAILABLE[sym] || raise("No such notification: #{sym}")
    end
  end
end
