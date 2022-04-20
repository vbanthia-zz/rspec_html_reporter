Given('a report has been generated') do
end

When('I visit the page: {string}') do |page_name|
  visit(page_name)
end

Then('the reports directory is created') do
  expect(Dir.exist?('reports/cg-test')).to be true
end

Then('a file named {string} is present') do |string|
  expect(File.exist?("reports/cg-test/#{string}")).to be true
end

Then('the report has the heading {string}') do |heading_text|
  expect(page).to have_css('h1', text: heading_text)
end

Then('the Report table has the correct column names') do
  expect(Capybara.all('.table').first.all('th').map(&:text)).to eq(Fig.group_column_names)
end

Then('the Spec group table has {int} links to other pages') do |number|
  expect(page).to have_css('tr td a', count: number)
end

Then('the correct Group name for each spec is displayed') do
  expect(page).to have_content('Example Test', count: 3)
  expect(page).to have_content('Embed Graphics', count: 1)
  expect(page).to have_content('RSpec HTML Reporter', count: 1)
  expect(page).to have_content('Shared Examples', count: 1)
  expect(page).to have_content('Turnip test cases', count: 1)
end

Then('the the correct results for each group are displayed in the summary table') do
  row_data = all('tbody tr').map do |r|
    r.all('td').map(&:text)
  end
  row_data.each { |row| row.delete_at(2) }
  row_data.each_with_index do |row, i|
    expect(row).to eq(Fig.overview_summary_results[i])
  end
end
