# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "i18n_global_scope"
  spec.version       = I18nGlobalScope::VERSION
  spec.authors       = ["Adrian Serafin"]
  spec.email         = ["abusiek@gmail.com"]
  spec.summary       = %q{Global scope for i18n gem.}
  spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'i18n'
  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rspec"
end
