# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a 
# newer version of cucumber-rails. Consider adding your own code to a new file 
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

ENV["RAILS_ENV"] ||= "test"
ENV["RAILS_ROOT"] ||= File.expand_path(File.dirname(__FILE__) + '/../../cucumber_test_app')

require 'capybara'
require 'cucumber/rails'
Capybara.default_selector = :css
ActionController::Base.allow_rescue = false
DatabaseCleaner.strategy = :truncation