# frozen_string_literal: true

module Helpers

  ##
  # Appends a number to duplicate filename to avoid them being overwritten
  # by Specs with the same description.
  #
  # Renames duplicate filenames for specs that have the same description
  # @param [String] filename  Duplicate filename to rename
  # @return [String]          Renamed filename
  ##
  def self.rename_duplicate_filename(filename)
    if File.exist?(filename)
      base, ext = /\A(.+?)(\.[^.]+)?\Z/.match(filename).to_a[1..]
      number = 2
      number += 1 while File.exist?(filename = "#{base}-#{number}#{ext}")
    end
    filename
  end

  ##
  # Appends a number to a duplicate description to avoid them being overwritten
  # by Specs with the same description.
  #
  # Renames duplicate descriptions for specs that have the same description
  # @param [Hash] group_name    Group name to check for duplicate keys
  # @param [String] description Duplicate description to rename
  # @return [String]            Renamed description
  ##
  def self.rename_duplicate_description(group_name, description)
    if group_name.key?(description)
      number = group_name.select { |k, _v| k.include?(description) }.length
      description = "#{description}-#{number + 1}"
    end
    description
  end

  ##
  # Allows the theme to be changed in the report template
  # @param [String] name  The name of the theme to be used with the report
  # @return [String]      The lowercase name of the chosen theme, defaults to the yeti theme if the ENV['THEME']
  # variable is not specified when running the tests
  ##
  def self.theme(name)
    name = name.downcase unless name.nil?
    case name
    when 'cerulean', 'litera', 'materia', 'sketchy', 'spacelab'
      name
    else
      'yeti'
    end
  end
end
