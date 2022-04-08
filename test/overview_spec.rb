# frozen_string_literal: true

require_relative './spec_helper'
require_relative './support/test_helper'

describe 'Report Overview' do
  before(:all) do
    TestHelper.remove_report_dir(FigNewton.reports_dir)
    system("REPORT_PATH=#{FigNewton.test_report_path} bundle exec rspec --format RspecPrettyHtmlReporter ../spec")
  end

  it 'creates a directory in the reports directory' do
    expect(Dir.exist?('reports/cg-test')).to be true
  end

  it 'creates a HTML file in the reports directory' do
    expect(File.exist?('reports/cg-test/overview.html')).to be true
  end

  it "contains a H1 with text 'Report Overview'" do
    visit '/overview.html'
    expect(page).to have_css('h1', text: 'Report Overview')
  end

  it 'Report table has the correct column names' do
    table_column_names = %w[# Group Duration Pending Failed Passed Status]
    visit '/overview.html'
    expect(Capybara.all('.table th').map(&:text)).to eq(table_column_names)
  end

  it 'has 6 Spec groups that have links' do
    visit '/overview.html'
    expect(page).to have_css('tr td a', count: 6)
  end

  it 'displays the correct Group name for each spec' do
    visit '/overview.html'
    expect(page).to have_content('Example Test', count: 3)
    expect(page).to have_content('Embed Graphics', count: 1)
    expect(page).to have_content('RSpec HTML Reporter', count: 1)
    expect(page).to have_content('Shared Examples', count: 1)
  end

  it 'displays the correct results for each group' do
    visit '/overview.html'
    row_data = all('tbody tr').map do |r|
      r.all('td').map(&:text)
    end
    row_data.each { |row| row.delete_at(2) }
    @examples = [['1', 'Example Test', '0', '1', '0', 'failed'],
                 ['2', 'Example Test', '0', '0', '1', 'passed'],
                 ['3', 'Example Test', '1', '0', '0', 'pending'],
                 ['4', 'Embed Graphics', '3', '3', '3', 'failed'],
                 ['5', 'RSpec HTML Reporter', '2', '3', '5', 'failed'],
                 ['6', 'Shared Examples', '0', '1', '1', 'failed']]
    row_data.each_with_index do |row, i|
      expect(row).to eq(@examples[i])
    end
  end
end
