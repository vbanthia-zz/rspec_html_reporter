# frozen_string_literal: true

require_relative './spec_helper'
require_relative './support/test_helper'

describe 'Example Test - Pending' do
  before(:all) do
    TestHelper.remove_report_dir(FigNewton.reports_dir)
    system("REPORT_PATH=#{FigNewton.test_report_path} bundle exec rspec --format RspecPrettyHtmlReporter ../spec")
  end

  it 'creates a directory in the reports directory' do
    expect(Dir.exist?(FigNewton.test_report_path)).to be true
  end

  it 'creates a HTML file in the reports directory' do
    expect(File.exist?("#{FigNewton.test_report_path}/example-test-3.html")).to be true
  end

  it "contains a link with text 'Back to report overview'" do
    visit '/example-test-3.html'
    expect(page).to have_css('a', text: FigNewton.back_link)
  end

  it 'displays a Report table with the correct column names' do
    visit '/example-test-3.html'
    expect(all('.table').first.all('th').map(&:text)).to eq(FigNewton.group_column_names)
  end

  it 'displays the correct results for the example group in the Report table' do
    visit '/example-test-3.html'
    all('tbody').first.find('tr') do |r|
      @row_data = r.all('td').map(&:text)
    end
    @row_data.delete_at(2)
    expect(@row_data).to eq(FigNewton.example_test_pending)
  end

  it 'displays an Example table with the correct column names' do
    visit '/example-test-3.html'
    expect(all('.table').last.all('th').map(&:text)).to eq(FigNewton.example_column_names)
  end

  it 'displays the correct title in the Example table' do
    visit '/example-test-3.html'
    expect(page).to have_css('h3.card-title', text: 'ExampleTest_3 → is pending')
  end

  it 'displays passed for the example group in the example table' do
    visit '/example-test-3.html'
    expect(page.all('tbody')[1].find('.badge').text).to eq('pending')
  end
end
