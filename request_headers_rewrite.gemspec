# frozen_string_literal: true
# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)

$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'request_headers_rewrite/version'

Gem::Specification.new do |gem|
  gem.name          = 'request_headers_rewrite'
  gem.version       = RequestHeadersRewrite::VERSION
  gem.authors       = ['Marc Grimme']
  gem.email         = ['marc.grimme@gmail.com']
  gem.description   = 'RequestHeaderRewrite lets you modify request headers'
  gem.summary       = 'RequestHeaderRewrite lets you modify request headers'
  gem.homepage      = 'http://github.com/marcgrimme/request_headers_rewrite'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rack'
  gem.add_development_dependency 'simplecov'
  gem.add_development_dependency 'rubocop'
end
