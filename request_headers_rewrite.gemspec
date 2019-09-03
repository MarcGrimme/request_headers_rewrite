# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

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

  gem.add_development_dependency 'rack', '~> 2.0.7'
  gem.add_development_dependency 'rake', '~> 12'
  gem.add_development_dependency 'rspec', '~> 3.8'
  gem.add_development_dependency 'rubocop', '~> 0.65'
  gem.add_development_dependency 'rubycritic', '~> 4.1'
  gem.add_development_dependency 'rubycritic-small-badge', '~> 0.2.1'
  gem.add_development_dependency 'simplecov', '~> 0.17'
  gem.add_development_dependency 'simplecov-small-badge', '~> 0.2.3'
end
