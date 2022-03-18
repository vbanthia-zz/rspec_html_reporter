require 'rbconfig'
require 'rspec/core/formatters/base_formatter'
require 'rouge'

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
      source = lines[start_line..end_line].join('').sub(lines[line_number - 1].chomp, "--->#{lines[line_number - 1].chomp}")
      formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight', line_numbers: true, start_line: start_line + 1)
      lexer = Rouge::Lexers::Ruby.new
      original_format = formatter.format(lexer.lex(source.encode('utf-8')))
      original_format.gsub!(/<table class="rouge-table">/, '<table class="rouge-table" style="width:100%">')
    end
  end

  def process_message
    formatter = Rouge::Formatters::HTMLLegacy.new(css_class: 'highlight pl-3')
    lexer = Rouge::Lexers::Ruby.new
    formatter.format(lexer.lex(@message))
  end
end
