# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kontena/plugin/console/version'

Gem::Specification.new do |spec|
  spec.name          = "kontena-plugin-console"
  spec.version       = Kontena::Plugin::Console::VERSION
  spec.authors       = ["Kontena, Inc."]
  spec.email         = ["info@kontena.io"]

  spec.summary       = "Kontena console plugin"
  spec.description   = "Kontena console plugin aka KOSH"
  spec.homepage      = "https://github.com/kontena/kontena-plugin-console"
  spec.license       = "Apache-2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'kontena-cli', '>= 1.1.5'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
