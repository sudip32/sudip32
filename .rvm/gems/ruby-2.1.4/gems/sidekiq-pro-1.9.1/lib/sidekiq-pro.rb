require 'sidekiq'
require 'sidekiq/pro/version'
require 'sidekiq/pro/worker'
require 'sidekiq/pro/api'
require 'sidekiq/batch'
require 'sidekiq/notifications'

Sidekiq.send(:remove_const, :LICENSE)
Sidekiq::NAME << " Pro"
Sidekiq::LICENSE = "Sidekiq Pro #{Sidekiq::Pro::VERSION}, commercially licensed.  Thanks for your support!"
Sidekiq.options[:notifications] = Hash.new({})

Sidekiq.configure_server do
  class Sidekiq::CLI
    def self.banner
      File.read(File.expand_path(File.join(__FILE__, '../sidekiq/intro.ans')))
    end
  end
end
