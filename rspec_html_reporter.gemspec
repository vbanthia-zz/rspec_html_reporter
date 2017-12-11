# -*- encoding : utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'rspec_html_reporter'
  spec.version       = '1.0.0'
  spec.authors       = ['Vishal Banthia']
  spec.email         = ['vishal.banthia.vb@gmail.com']
  spec.summary       = 'RSpec HTML Reporter'
  spec.description   = 'RSpec HTML Reporter'
  spec.homepage      = 'https://github.com/vbanthia/rspec_html_reporter'
  spec.licenses      = ["MIT"]

  spec.required_ruby_version = '>= 2.2.2'
  spec.files = Dir['{lib,resources,templates}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")

  spec.add_runtime_dependency('rspec')
  spec.add_runtime_dependency('rouge', '~> 1.6')
  spec.add_runtime_dependency('activesupport')

  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('pry')
  spec.add_development_dependency('rake')
  spec.add_development_dependency('rubocop')
end
