require 'rspec'

RSpec.shared_examples "foo" do |arg|
  it "works" do
    expect("foo").to eq(arg)
  end
end
