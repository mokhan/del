
# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'del/version'

Gem::Specification.new do |spec|
  spec.name          = 'del'
  spec.version       = Del::VERSION
  spec.authors       = ['mo']
  spec.email         = ['mo@mokhan.ca']

  spec.summary       = 'Del is a funky robosapien.'
  spec.description   = 'Del is a funky robosapien.'
  spec.homepage      = 'https://www.mokhan.ca'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.5.0'
  spec.metadata = {
    'source_code_uri' => 'https://github.com/mokhan/del'
  }

  spec.add_dependency 'net-hippie', '~> 0.1'
  spec.add_dependency 'thor', '~> 0.20'
  spec.add_dependency 'xmpp4r', '~> 0.5'
  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'bundler-audit', '~> 0.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 0.55'
  spec.add_development_dependency 'simplecov', '~> 0.16'
end
