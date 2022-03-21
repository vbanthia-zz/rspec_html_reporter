# -*- encoding : utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'rspec_pretty_html_reporter'
  spec.version       = '1.1.0'
  spec.authors       = ['Carlos Gutierrez']
  spec.email         = ['testing@spartan-testsolutions.co.uk']
  spec.summary       = 'RSpec Pretty HTML Reporter'
  spec.description   = 'A custom reporter for RSpec which generates pretty HTML reports'
  spec.homepage      = 'https://github.com/TheSpartan1980/rspec_pretty_html_reporter'
  spec.licenses      = ['MIT']

  spec.required_ruby_version = '>= 2.7.5'
  spec.files = Dir['{lib,resources,templates}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")

  spec.add_runtime_dependency('activesupport', '~> 7.0')
  spec.add_runtime_dependency('rouge', '~> 3.28')
  spec.add_runtime_dependency('rspec-core', '~>3.4')

  spec.add_development_dependency('byebug', '~> 11.1')
  spec.add_development_dependency('pry', '~> 0.14')
  spec.add_development_dependency('rdoc', '~> 6.4')
  spec.add_development_dependency('rspec', '~> 3.4.0')
  spec.add_development_dependency('turnip', '~> 2.0', '>= 2.0.2')
end
