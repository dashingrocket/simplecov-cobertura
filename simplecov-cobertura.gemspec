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
  spec.required_ruby_version = '>= 1.9.3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'test-unit', '~> 3.2'
  spec.add_development_dependency 'nokogiri', '~> 1.0'

  spec.add_dependency 'simplecov', '~> 0.8'

  if RUBY_VERSION < '2.0'
    spec.add_dependency 'json', '< 2.3.0'
    spec.add_development_dependency 'rake', '~> 12.0', '< 12.3'
  elsif RUBY_VERSION < '2.2'
    spec.add_development_dependency 'rake', '~> 12.0'
  else
    spec.add_development_dependency 'rake', '~> 13.0'
  end

  spec.add_dependency 'rexml'
end
