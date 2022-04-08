# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'rspec_pretty_html_reporter'
  spec.version       = '1.1.2'
  spec.authors       = ['Carlos Gutierrez']
  spec.email         = ['testing@spartan-testsolutions.co.uk']
  spec.summary       = 'RSpec Pretty HTML Reporter'
  spec.description   = 'A custom reporter for RSpec which generates pretty HTML reports'
  spec.homepage      = 'https://github.com/TheSpartan1980/rspec_pretty_html_reporter'
  spec.licenses      = ['MIT']

  spec.required_ruby_version = '>= 2.7.5'
  spec.files = Dir['{lib,resources,templates}/**/*', 'README*', 'LICENSE*'] & `git ls-files -z`.split("\0")

  spec.add_runtime_dependency('activesupport', '~> 7.0')
  spec.add_runtime_dependency('bundler', '~> 2.3')
  spec.add_runtime_dependency('rouge', '~> 3.28')
  spec.add_runtime_dependency('rspec-core', '~> 3.11.0')

  spec.add_development_dependency('byebug', '~> 11.1')
  spec.add_development_dependency('capybara', '~> 3.36')
  spec.add_development_dependency('rake', '~> 13.0')
  spec.add_development_dependency('rdoc', '~> 6.4')
  spec.add_development_dependency('rspec', '~> 3.11.0')
  spec.add_development_dependency('turnip', '~> 2.0', '>= 2.0.2')
  spec.add_development_dependency('webdrivers', '~> 5.0')
end
