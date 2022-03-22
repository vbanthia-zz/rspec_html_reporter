# frozen_string_literal: true

require 'rspec'

require_relative 'support/shared_examples/from_another_file'

RSpec.describe 'Shared Examples' do
  include_examples 'from another file', :should_pass
  include_examples 'from another file', :should_fail
end
