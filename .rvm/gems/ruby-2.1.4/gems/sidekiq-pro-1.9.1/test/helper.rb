ENV['RACK_ENV'] = 'test'
$TESTING = true
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

require 'sidekiq-pro'
require 'webmock/minitest'

REDIS = Redis.new(:url => "redis://localhost/14")
REDIS.flushdb

Sidekiq.redis = { :url =>  "redis://localhost/14" }

Sidekiq.options[:web] = 'http://example.org/sidekiq'
Sidekiq.options[:notifications][:webhook] = {
  url: 'https://some.acmecorp.com/foo/bar',
  username: 'mike',
  password: 'whizzy'
}
Sidekiq.options[:notifications][:email] = {
  :to => 'Mike Perham <mperham@gmail.com>',
  :from => 'Sidekiq <mperham@gmail.com>',
  :via => :smtp,
  :via_options => {
    :address        => '127.0.0.1',
    :port           => '1025',
  }
}

Sidekiq.logger = nil

require 'sidekiq/testing'
Sidekiq::Testing.disable!
