# frozen_string_literal: true

require 'byebug'
require 'capybara'
require 'capybara/cucumber'
require 'cucumber'
require 'fig_newton'
require 'selenium-webdriver'
require_relative 'test_helper'

Fig = FigNewton
Fig.yml_directory = 'fixtures'

TestHelper.remove_report_dir(FigNewton.reports_dir)
system("REPORT_PATH=#{FigNewton.test_report_path} bundle exec rspec --format RspecPrettyHtmlReporter spec")
