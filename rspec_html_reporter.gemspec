lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "turnip_html_reporter"
  spec.version       = "1.0.0"
  spec.authors       = ["Tadashi Nemoto"]
  spec.email         = ["tadashi.nemoto0713@gmail.com"]
  spec.summary       = "Turnip HTML Reporter"
  spec.description   = "Turnip HTML Reporter"
  spec.homepage      = "https://github.com/tadashi0713/turnip_html_reporter"
  spec.licenses      = ["MIT"]

  spec.required_ruby_version = ">= 2.2.2"
  spec.files = Dir["{lib,resources,templates}/**/*", "README*", "LICENSE*"] & `git ls-files -z`.split("\0")

  spec.add_runtime_dependency("activesupport")
  spec.add_runtime_dependency("rouge", "~> 1.6")
  spec.add_runtime_dependency("rspec")
  spec.add_runtime_dependency("turnip")

  spec.add_development_dependency("pry")
  spec.add_development_dependency("rake")
  spec.add_development_dependency("rdoc")
  spec.add_development_dependency("rubocop")
end
