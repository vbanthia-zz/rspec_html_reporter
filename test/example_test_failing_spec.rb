# frozen_string_literal: true

require_relative './spec_helper'
require_relative './support/test_helper'

describe 'Example Test - Failing' do
  before(:all) do
    TestHelper.remove_report_dir('reports')
    system('REPORT_PATH=reports/cg-test bundle exec rspec --format RspecPrettyHtmlReporter ../spec')
  end

  it 'creates a directory in the reports directory' do
    expect(Dir.exist?('reports/cg-test')).to be true
  end

  it 'creates a HTML file in the reports directory' do
    expect(File.exist?('reports/cg-test/example-test.html')).to be true
  end

  it "contains a link with text 'Back to report overview'" do
    visit '/example-test.html'
    expect(page).to have_css('a', text: 'Back to report overview')
  end

  it 'displays a Report table with the correct column names' do
    table_column_names = %w[# Group Duration Pending Failed Passed Status]
    visit '/example-test.html'
    expect(all('.table').first.all('th').map(&:text)).to eq(table_column_names)
  end

  it 'displays the correct results for the example group in the Report table' do
    visit '/example-test.html'
    all('tbody').first.find('tr') do |r|
      @row_data = r.all('td').map(&:text)
    end
    @row_data.delete_at(2)
    @examples = ['1', 'Example Test', '0', '1', '0', 'failed']
    expect(@row_data).to eq(@examples)
  end

  it 'displays an Example table with the correct column names' do
    table_column_names = %w[# Example Duration Status]
    visit '/example-test.html'
    expect(all('.table').last.all('th').map(&:text)).to eq(table_column_names)
  end

  it 'displays the correct title in the Example table' do
    visit '/example-test.html'
    expect(page).to have_css('h3.card-title', text: 'ExampleTest → fails')
  end

  it 'displays the highlighted code "supposed to fail" for the example group in the Example table' do
    visit '/example-test.html'
    expect(page.all('.card-body .highlight').first.text).to eq('supposed to fail')
  end

  it 'displays the highlighted code that is failing for example group in the Example table' do
    visit '/example-test.html'
    expect(page.all('.card-body .highlight').last.text).to eq("6\n7\n8\n9\n  it 'fails' do\n--->    raise 'supposed to fail'\n  end\nend")
  end

  it 'displays failed for the example group in the example table' do
    visit '/example-test.html'
    expect(page.all('tbody')[1].find('.badge').text).to eq('failed')
  end
end
