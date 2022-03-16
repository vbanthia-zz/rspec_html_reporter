require 'rouge'
require 'rspec_html_reporter/oopsy'

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

  def klass(prefix = 'badge-')
    class_map = { passed: "#{prefix}success", failed: "#{prefix}danger", pending: "#{prefix}warning" }
    class_map[@status.to_sym]
  end
end
