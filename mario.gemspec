$:.unshift File.expand_path("../lib", __FILE__)
require "mario/version"

Gem::Specification.new do |s|
  s.name          = "mario"
  s.version       = Mario::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ["John Bender"]
  s.email         = ["john.m.bender@gmail.com"]
  s.homepage      = "http://github.com/johnbender/mario"
  s.summary       = "Mario is a collection of utilities for dealing with platform specific issues."
  s.description   = "Mario is a collection of utilities for dealing with platform specific issues."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "mario"

  s.add_development_dependency "shoulda", ">= 0"
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path  = 'lib'
end
