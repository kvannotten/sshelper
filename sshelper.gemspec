# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sshelper/version'

Gem::Specification.new do |spec|
  spec.name          = "sshelper"
  spec.version       = Sshelper::VERSION
  spec.authors       = ["Kristof Vannotten"]
  spec.email         = ["kristof@vannotten.be"]
  spec.description   = %q{Small application that helps you doing to automate mundane, remote tasks}
  spec.summary       = %q{Small application that helps you doing to automate mundane, remote tasks}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  
  spec.add_dependency "net-ssh"
end
