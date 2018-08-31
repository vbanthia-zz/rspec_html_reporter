require 'rspec'

require_relative './support/shared_examples/foo'

RSpec.describe "Example Group" do
  include_examples "foo", "foo"
  include_examples "foo", "bar"
end
