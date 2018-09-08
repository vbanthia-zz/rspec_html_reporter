require 'rspec'

RSpec.shared_examples "from another file" do |expected|
  it "works" do
    #-> Given a shared example with spec
    expect(expected).to eq(:should_pass)
  end
end
