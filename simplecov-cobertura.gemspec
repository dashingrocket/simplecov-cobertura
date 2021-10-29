# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'simplecov-cobertura/version'

Gem::Specification.new do |spec|
  spec.name          = 'simplecov-cobertura'
  spec.version       = SimpleCov::Formatter::CoberturaFormatter::VERSION
  spec.authors       = ['Jesse Bowes']
  spec.email         = ['jbowes@dashingrocket.com']
  spec.summary       = 'SimpleCov Cobertura Formatter'
  spec.description   = 'Produces Cobertura XML formatted output from SimpleCov'
  spec.homepage      = 'https://github.com/dashingrocket/simplecov-cobertura'
  spec.license       = 'Apache-2.0'
  spec.required_ruby_version = '> 2.5'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'test-unit'
  spec.add_development_dependency 'nokogiri'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rexml'

  spec.add_dependency 'simplecov'
end
