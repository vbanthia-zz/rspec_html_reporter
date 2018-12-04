require 'rspec'

describe 'RSpec HTML Reporter' do

  it 'should do cool test stuff' do
    pending('coming soon')
    fail
  end

  it 'should do amazing test stuff' do
    expect('boats').to eq 'boats'
  end

  it 'should do superb test stuff' do
    #-> Given there are some ships
    #-> When I sail one
    #-> Then it should go fast
    expect('ships').to eq 'ships'
  end

  it 'should do example stuff' do
    expect('apple').to eq 'apple'
    expect('pear').to eq 1
    #-> Given I have some stuff to do
    #-> And I like to do is wait here for a while
    #-> Then I do it real good!!
  end

  it 'should do very cool test stuff' do
    #-> Given I have some cars
    expect('cars').to eq 'cars'
    #-> And I drive one of them
    expect('diesel').to eq 'diesels'
    #-> Then I should go fast
    expect('apple').to eq 'apple'
  end

  it 'should do very amazing test stuff' do
    expect('boats').to eq 'boats'
  end

  it 'should do very superb test stuff' do
    expect('ships').to eq 'ships'
  end

  it 'should do very rawesome test stuff' do
    #-> Given I have some cars
    pending('give me a woop')
    fail
  end

  it 'should do insane and cool test stuff' do
    expect('ships').to eq 'ships'
  end

  # MultipleExceptionError will be thrown above RSpec v3.3.0
  describe 'Throw multiple exception' do
    it "raise error" do
      raise "This is an exception in test"
    end

    after :each do
      raise "This is an exception in after method"
    end
  end

  it 'should do commented stuff' do |example|
    example.metadata[:comment] = 'This is an example comment!'
    expect('something').to eq 'something'
  end

  describe 'Default comment' do
    before :each do |example|
      example.metadata[:comment] = 'A default comment'
    end

    it 'has default comment' do
      expect('something').to eq 'something'
    end

    it 'overrides a comment' do |example|
      example.metadata[:comment] = 'A better, happier comment'
      expect('something').to eq 'something'
    end

    it 'shows a default comment for failure' do
      expect('something').to eq 'something else'
    end
  end
end
