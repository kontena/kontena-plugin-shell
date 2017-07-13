# coding: utf-8
lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'kontena/plugin/shell/version'

Gem::Specification.new do |spec|
  spec.name          = "kontena-plugin-shell"
  spec.version       = Kontena::Plugin::Shell::VERSION
  spec.authors       = ["Kontena, Inc."]
  spec.email         = ["info@kontena.io"]

  spec.summary       = "Kontena interactive shell plugin"
  spec.description   = "Interactive shell for Kontena CLI aka KOSH"
  spec.homepage      = "https://github.com/kontena/kontena-plugin-shell"
  spec.license       = "Apache-2.0"

  spec.files         = Dir['LICENSE.txt', 'README.md', 'lib/**/*.rb', 'spec/**/*.rb', 'bin/*', '.rspec']
  spec.test_files    = spec.files.grep(%r{^spec//}) { |f| File.basename(f) } + ['.rspec']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  if ENV['CLI_VERSION']
    spec.add_runtime_dependency 'kontena-cli', "~> #{ENV['CLI_VERSION']}"
  else
    spec.add_runtime_dependency 'kontena-cli', '~> 1.0'
  end
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
