Capybara.configure do |config|
  config.app_host = "file:///#{Bundler.root}/reports/cg-test"
  config.default_max_wait_time = 3
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
