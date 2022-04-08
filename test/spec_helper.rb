# frozen_string_literal: true

require 'capybara/dsl'
require 'capybara/rspec'
require 'fig_newton'
require 'rack'
require 'rspec'
require 'webdrivers'

Capybara.configure do |config|
  config.app_host = "file:///#{Bundler.root}/test/reports/cg-test"
  config.default_max_wait_time = 5
  config.default_selector = :css
  config.exact = true
  config.ignore_hidden_elements = true
  config.match = :prefer_exact
  config.run_server = false
end

Capybara.default_driver = case ENV['BROWSER']
                          when 'chrome'
                            :selenium_chrome
                          when 'firefox'
                            :selenium
                          when 'headless'
                            :selenium_chrome_headless
                          else
                            :selenium_chrome_headless
                          end

RSpec.configure do |config|
  config.include Capybara::DSL
end

FigNewton.yml_directory = 'fixtures'
