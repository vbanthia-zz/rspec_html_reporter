Then('the report has the link {string}') do |link_name|
  expect(page).to have_css('a', text: link_name)
end

Then('the example group in the Report table displays the correct results') do
  all('tbody').first.find('tr') do |r|
    @row_data = r.all('td').map(&:text)
  end
  @row_data.delete_at(2)
  expect(@row_data).to eq(Fig.example_test_failed)
end

Then('the example table has the correct columns') do
  expect(all('.table').last.all('th').map(&:text)).to eq(Fig.example_column_names)
end

Then('the title in the example table is correct') do
  expect(page).to have_css('h3.card-title', text: 'ExampleTest → fails')
end

Then('{string} is highlighted error message in the example') do |error_massage|
  expect(page.all('.card-body .highlight').first.text).to eq(error_massage)
end

Then('the failing code highlighted for the example is:') do |code_block|
  expect(page.all('.card-body .highlight').last.text).to eq(code_block)
end

Then('the status of the example is {string} in the example table') do |example_status|
  expect(page.all('tbody')[1].find('.badge').text).to eq(example_status)
end
