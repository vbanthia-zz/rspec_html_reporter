# frozen_string_literal: true

require 'rspec'

describe 'Example Test' do
  # Intentional mistake to enable the specs shows as pending.
  xit 'is pending' do
    expect(true).to be(false)
  end
end
