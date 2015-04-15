# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'confidential_info_redactor/version'

Gem::Specification.new do |spec|
  spec.name          = "confidential_info_redactor"
  spec.version       = ConfidentialInfoRedactor::VERSION
  spec.authors       = ["Kevin S. Dias"]
  spec.email         = ["diasks2@gmail.com"]
  spec.summary       = %q{Semi-automatically redact confidential information from a text}
  spec.description   = %q{A Ruby gem to semi-automatically redact confidential information from a text}
  spec.homepage      = "https://github.com/diasks2/confidential_info_redactor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "pragmatic_segmenter"
end
