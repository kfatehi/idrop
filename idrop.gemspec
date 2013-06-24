# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idrop/version'

Gem::Specification.new do |spec|
  spec.name          = "idrop"
  spec.version       = Idrop::VERSION
  spec.authors       = ["Keyvan Fatehi", "Jeanre Swanepoel"]
  spec.email         = ["keyvanfatehi@gmail.com", "jeanre.swanepoel@gmail.com"]
  spec.description   = %q{for mkv appearing in a folder, it converts to mp4, transfers with scp, and deletes}
  spec.summary       = %q{mkv to mp4 to scp}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "net-scp"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
