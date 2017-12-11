# -*- coding: utf-8 -*-

require_relative './adb'

module ScreenUtil

  include ::AdbUtil

  SCREENRECORD_DEVICE_PATH = '/sdcard/screenrecord.mp4'

  @@screenrecord_pid   = nil
  @@screenrecord_count = 0
  @@screenshot_count   = 0

  def start_screenrecord
    if @@screenrecord_pid
      stop_screenrecord
    end

    cmd = "adb shell screenrecord #{SCREENRECORD_DEVICE_PATH}"
    @@screenrecord_pid = spawn(cmd, :out => '/dev/null')

    Process.detach(@@screenrecord_pid)
  end

  def stop_screenrecord
    begin
      Process.kill('TERM', @@screenrecord_pid)

      # TODO: Figure out better way to know screenrecord is dead in device
      sleep 2
    rescue Errno::ESRCH => e
      # Process already killed
    end

    @@screenrecord_pid = nil
  end

  def pull_screenrecord
    path = File.join(screenrecord_dir, "screenrecord_#{next_screenrecord_count}.mp4")

    begin
      cmd = "pull #{SCREENRECORD_DEVICE_PATH} #{path}"
      execute_adb(cmd)

      cmd = "shell rm #{SCREENRECORD_DEVICE_PATH}"
      execute_adb(cmd)
    rescue Exception => e
      # do nothing
    end

    path
  end

  def take_screenshot(prefix: nil)
    img_name = "img_#{ next_screenshot_count }.png"
    img_name =  "#{ prefix }_#{ img_name }" unless prefix.nil?
    img_path = File.join(screenshot_dir, img_name)
    begin
      $driver.screenshot(img_path)
    rescue => e
      $stderr.puts "saving screenshot failed #{ e.message }"
    end
    img_path
  end

  def next_screenrecord_count
    @@screenrecord_count += 1
  end

  def next_screenshot_count
    @@screenshot_count += 1
  end

  def screenrecord_dir
    @screenrecord_dir ||= RspecHtmlReporter::SCREENRECORD_DIR
  end

  def screenshot_dir
    @screenshot_dir ||= RspecHtmlReporter::SCREENSHOT_DIR
  end
end
