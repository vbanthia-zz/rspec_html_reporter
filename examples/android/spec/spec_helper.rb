# -*- coding: utf-8 -*-

require 'appium_lib'


# support files
SPEC_ROOT = File.expand_path(File.dirname(__FILE__))
Dir[File.expand_path('support/**/*.rb', SPEC_ROOT)].each { |f| require f }

app_path = File.join(Bundler.root, 'apks', 'android-sample-app.apk')

RSpec.configure do |config|

  config.include ::ScreenUtil
  config.include ::PathUtil

  config.before(:suite) do
    driver_caps = {
      platformName: :android,
      deviceName: 'Android',
      newCommandTimeout: 9999,
      app: app_path
    }

    Appium::Driver.new({caps: driver_caps}, true).start_driver
  end

  config.before do |example|
    start_screenrecord
  end

  config.after do |example|
    stop_screenrecord
    example.metadata[:screenrecord] = screenrecord_rel_path(pull_screenrecord)

    if example.exception
      example.metadata[:failed_screenshot] = screenshot_rel_path(take_screenshot)
    end
  end

  config.after(:suite) do
    $driver.driver_quit
  end
end
