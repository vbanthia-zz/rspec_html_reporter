# -*- coding: utf-8 -*-

RSpec.describe 'Subtraction' do
  let!(:x) { 15 }
  let!(:y) { 5 }

  before do
    $driver.find_element(:accessibility_id, 'resetButton').click
    sleep 1

    $driver.find_element(:accessibility_id, 'inputFieldLeft').send_key(x)
    $driver.find_element(:accessibility_id, 'inputFieldRight').send_key(y)
    sleep 1
  end

  it 'subtract two numbers' do
    $driver.find_element(:accessibility_id, 'subtractButton').click
    sleep 1

    result_text = $driver.find_element(:accessibility_id, 'resultTextView').text
    expected_result = "%.2f" % x + " - " + "%.2f" % y + " = " + "%.2f" % (x - y)
    expect(result_text).to eq(expected_result)
  end
end
