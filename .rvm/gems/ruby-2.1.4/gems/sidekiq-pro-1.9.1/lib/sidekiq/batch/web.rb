puts "Deprecated, please require 'sidekiq/pro/web' now at #{caller.detect {|line| line !~ /require|activesupport/}}"
