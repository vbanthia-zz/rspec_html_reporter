# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/inflector'
require 'fileutils'
require 'erb'
require 'rspec_pretty_html_reporter/example'

I18n.enforce_available_locales = false

class RspecHtmlReporter < RSpec::Core::Formatters::BaseFormatter
  DEFAULT_REPORT_PATH = File.join(Bundler.root, 'reports', Time.now.strftime('%Y%m%d-%H%M%S'))
  REPORT_PATH = ENV['REPORT_PATH'] || DEFAULT_REPORT_PATH

  SCREENRECORD_DIR = File.join(REPORT_PATH, 'screenrecords')
  SCREENSHOT_DIR = File.join(REPORT_PATH, 'screenshots')
  RESOURCE_DIR = File.join(REPORT_PATH, 'resources')

  RSpec::Core::Formatters.register self, :example_started, :example_passed, :example_failed, :example_pending,
                                   :example_group_finished

  def initialize(_io_standard_out)
    create_reports_dir
    create_screenshots_dir
    create_screenrecords_dir
    copy_resources
    @all_groups = {}

    @group_level = 0
  end

  def example_group_started(_notification)
    if @group_level.zero?
      @example_group = {}
      @examples = []
      @group_example_count = 0
      @group_example_success_count = 0
      @group_example_failure_count = 0
      @group_example_pending_count = 0
    end

    @group_level += 1
  end

  def example_started(_notification)
    @group_example_count += 1
  end

  def example_passed(notification)
    # require 'byebug'; byebug

    @group_example_success_count += 1
    @examples << Example.new(notification.example)
  end

  def example_failed(notification)
    @group_example_failure_count += 1
    @examples << Example.new(notification.example)
  end

  def example_pending(notification)
    @group_example_pending_count += 1
    @examples << Example.new(notification.example)
  end

  def example_group_finished(notification)
    @group_level -= 1

    if @group_level.zero?

      File.open("#{REPORT_PATH}/#{notification.group.description.parameterize}.html", 'w') do |f|
        @passed = @group_example_success_count
        @failed = @group_example_failure_count
        @pending = @group_example_pending_count

        duration_values = @examples.map(&:run_time)

        duration_keys = duration_values.size.times.to_a
        if (duration_values.size < 2) && duration_values.size.positive?
          duration_values.unshift(duration_values.first)
          duration_keys = duration_keys << 1
        end

        @title = notification.group.description
        @durations = duration_keys.zip(duration_values)

        @summary_duration = duration_values.inject(0) { |sum, i| sum + i }.to_fs(:rounded, precision: 5)
        Example.load_spec_comments!(@examples)

        @total_group_examples = @passed + @failed + @pending


        class_map = { passed: 'success', failed: 'danger', pending: 'warning' }
        statuses = @examples.map(&:status)
        @status = if statuses.include?('failed')
                    'failed'
                  else
                    (statuses.include?('passed') ? 'passed' : 'pending')
                  end
        @all_groups[notification.group.description.parameterize] = {
          group: notification.group.description,
          examples: @examples.size,
          status: @status,
          klass: class_map[@status.to_sym],
          passed: statuses.select { |s| s == 'passed' },
          failed: statuses.select { |s| s == 'failed' },
          pending: statuses.select { |s| s == 'pending' },
          duration: @summary_duration
        }

        @example_status = @all_groups[notification.group.description.parameterize][:klass]

        template_file = File.read("#{File.dirname(__FILE__)}/../templates/report.erb")

        f.puts ERB.new(template_file).result(binding)
      end
    end
  end

  def close(notification)
    File.open("#{REPORT_PATH}/overview.html", 'w') do |f|
      @overview = @all_groups

      @passed = @overview.values.map { |g| g[:passed].size }.inject(0) { |sum, i| sum + i }
      @failed = @overview.values.map { |g| g[:failed].size }.inject(0) { |sum, i| sum + i }
      @pending = @overview.values.map { |g| g[:pending].size }.inject(0) { |sum, i| sum + i }

      duration_values = @overview.values.map { |e| e[:duration] }

      duration_keys = duration_values.size.times.to_a
      if duration_values.size < 2
        duration_values.unshift(duration_values.first)
        duration_keys = duration_keys << 1
      end

      @durations = duration_keys.zip(duration_values.map { |d| d.to_f.round(5) })
      @summary_duration = duration_values.map do |d|
        d.to_f.round(5)
      end.inject(0) { |sum, i| sum + i }.to_fs(:rounded, precision: 5)
      @total_examples = @passed + @failed + @pending
      template_file = File.read("#{File.dirname(__FILE__)}/../templates/overview.erb")
      f.puts ERB.new(template_file).result(binding)
    end
  end

  private

  def create_reports_dir
    FileUtils.rm_rf(REPORT_PATH) if File.exist?(REPORT_PATH)
    FileUtils.mkpath(REPORT_PATH)
  end

  def create_screenshots_dir
    FileUtils.mkdir_p SCREENSHOT_DIR unless File.exist?(SCREENSHOT_DIR)
  end

  def create_screenrecords_dir
    FileUtils.mkdir_p SCREENRECORD_DIR unless File.exist?(SCREENRECORD_DIR)
  end

  def copy_resources
    FileUtils.cp_r("#{File.dirname(__FILE__)}/../resources", REPORT_PATH)
  end
end
