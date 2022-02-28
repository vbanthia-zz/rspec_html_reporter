# frozen_string_literal: true

require 'rspec/core/formatters/base_formatter'
require 'active_support'
require 'active_support/core_ext/numeric'
require 'active_support/inflector'
require 'fileutils'
require 'rouge'
require 'erb'
require 'rbconfig'

I18n.enforce_available_locales = false

class Oopsy
  attr_reader :klass, :message, :backtrace, :highlighted_source, :explanation, :backtrace_message

  def initialize(example, file_path)
    @example = example
    @exception = @example.exception
    @file_path = file_path
    unless @exception.nil?
      @klass = @exception.class
      @message = @exception.message.encode('utf-8')
      @backtrace = @exception.backtrace
      @backtrace_message = formatted_backtrace(@example, @exception)
      @highlighted_source = process_source
      @explanation = process_message
    end
  end

  private

  def os
    @os ||= begin
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise StandardError, "unknown os: #{host_os.inspect}"
      end
    end
  end

  def formatted_backtrace(example, exception)
    # To avoid an error in format_backtrace. RSpec's version below v3.5 will throw exception.
    return [] unless example

    formatter = RSpec.configuration.backtrace_formatter
    formatter.format_backtrace(exception.backtrace, example.metadata)
  end

  def process_source
    return '' if @backtrace_message.empty?

    data = @backtrace_message.first.split(':')
    unless data.empty?
      if os == :windows
        file_path = "#{data[0]}:#{data[1]}"
        line_number = data[2].to_i
      else
        file_path = data.first
        line_number = data[1].to_i
      end
      lines = File.readlines(file_path)
      start_line = line_number - 2
      end_line = line_number + 3
      source = lines[start_line..end_line].join('').sub(lines[line_number - 1].chomp,
                                                        "--->#{lines[line_number - 1].chomp}")

      formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight', line_numbers: true,
                                                    start_line: start_line + 1)
      lexer = Rouge::Lexers::Ruby.new
      formatter.format(lexer.lex(source.encode('utf-8')))
    end
  end

  def process_message
    formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight')
    lexer = Rouge::Lexers::Ruby.new
    formatter.format(lexer.lex(@message))
  end
end

class Example
  def self.load_spec_comments!(examples)
    examples.group_by(&:file_path).each do |file_path, file_examples|
      lines = File.readlines(file_path)

      file_examples.zip(file_examples.rotate).each do |ex, next_ex|
        lexically_next = next_ex &&
                         next_ex.file_path == ex.file_path &&
                         next_ex.metadata[:line_number] > ex.metadata[:line_number]
        start_line_idx = ex.metadata[:line_number] - 1
        next_start_idx = (lexically_next ? next_ex.metadata[:line_number] : lines.size) - 1
        spec_lines = lines[start_line_idx...next_start_idx].select { |l| l.match(/#->/) }
        ex.set_spec(spec_lines.join) unless spec_lines.empty?
      end
    end
  end

  attr_reader :example_group, :description, :full_description, :run_time, :duration, :status, :exception, :file_path,
              :metadata, :spec, :screenshots, :screenrecord, :failed_screenshot

  def initialize(example)
    @example_group = example.example_group.to_s
    @description = example.description
    @full_description = example.full_description
    @execution_result = example.execution_result
    @run_time = (@execution_result.run_time).round(5)
    @duration = @execution_result.run_time.to_fs(:rounded, precision: 5)
    @status = @execution_result.status.to_s
    @metadata = example.metadata
    @file_path = @metadata[:file_path]
    @exception = Oopsy.new(example, @file_path)
    @spec = nil
    @screenshots = @metadata[:screenshots]
    @screenrecord = @metadata[:screenrecord]
    @failed_screenshot = @metadata[:failed_screenshot]
  end

  def example_title
    title_arr = @example_group.to_s.split('::') - %w[RSpec ExampleGroups]
    title_arr.push @description

    title_arr.join(' → ')
  end

  def has_exception?
    !@exception.klass.nil?
  end

  def has_spec?
    !@spec.nil?
  end

  def has_screenshots?
    !@screenshots.nil? && !@screenshots.empty?
  end

  def has_screenrecord?
    !@screenrecord.nil?
  end

  def has_failed_screenshot?
    !@failed_screenshot.nil?
  end

  def set_spec(spec_text)
    formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight')
    lexer = Rouge::Lexers::Gherkin.new
    @spec = formatter.format(lexer.lex(spec_text.gsub('#->', '')))
  end

  def klass(prefix = 'label-')
    class_map = { passed: "#{prefix}success", failed: "#{prefix}danger", pending: "#{prefix}warning" }
    class_map[@status.to_sym]
  end
end

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
