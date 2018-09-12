
step 'this is when steps' do
  # noop
  var = 1
end

step 'should do success test stuff' do
  expect('apple').to eq 'apple'
  expect(1).to eq 1
end

step 'should do pending test stuff' do
  pending('coming soon')
  fail
end

step 'should do assertion error test stuff' do
  expect('apple').to eq 'apple'
  expect('pear').to eq 1
end
