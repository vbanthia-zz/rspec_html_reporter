# frozen_string_literal: true

module TestHelper
  def self.remove_report_dir(dir_name)
    FileUtils.remove_dir(dir_name) if Dir.exist?(dir_name)
  end
end
