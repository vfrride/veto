# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'veto/version'

Gem::Specification.new do |spec|
  spec.name          = "veto"
  spec.version       = Veto::VERSION
  spec.authors       = ["Erik Lott"]
  spec.email         = ["erik.lott@kodio.com"]
  spec.description   = %q{Validations for plain ruby objects}
  spec.summary       = %q{Simple validations for plain ruby objects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha", "~> 0.14.0"
end
