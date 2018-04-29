
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "del/version"

Gem::Specification.new do |spec|
  spec.name          = "del"
  spec.version       = Del::VERSION
  spec.authors       = ["mo"]
  spec.email         = ["mo@mokhan.ca"]

  spec.summary       = %q{Del is a funky robosapien.}
  spec.description   = %q{Del is a funky robosapien.}
  spec.homepage      = "https://www.mokhan.ca"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "dotenv", "~> 2.4"
  spec.add_dependency "xmpp4r", "~> 0.5"
  spec.add_dependency "thor", "~> 0.20"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
