RSpec.describe "Subtraction" do
  let!(:x) { 15 }
  let!(:y) { 5 }

  before do
    @driver.find_element(:accessibility_id, "resetButton").click
    sleep 1

    @driver.find_element(:accessibility_id, "inputFieldLeft").send_key(x)
    @driver.find_element(:accessibility_id, "inputFieldRight").send_key(y)
    sleep 1
  end

  it "subtract two numbers" do
    @driver.find_element(:accessibility_id, "subtractButton").click
    sleep 1

    result_text = @driver.find_element(:accessibility_id, "resultTextView").text
    expected_result = format("%.2f", x) + " - " + format("%.2f", y) + " = " + format("%.2f", (x - y))
    expect(result_text).to eq(expected_result)
  end
end
