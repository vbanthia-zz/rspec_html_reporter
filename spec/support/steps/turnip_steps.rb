
step 'something' do
  # noop
  var = 1
end

step 'it passes' do
  expect('apple').to eq 'apple'
  expect(1).to eq 1
end

step 'it is pending' do
  pending('coming soon')
  fail
end

step 'it fails' do
  expect('apple').to eq 'apple'
  expect('pear').to eq 1
end
