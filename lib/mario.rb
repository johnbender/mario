
require 'rbconfig'
require 'logger'
lib = File.dirname(__FILE__)
%w{  
mario/util/object mario/hats/nix mario/hats/windows 
mario/platform mario/tools
}.each { |file| require File.expand_path(file, lib) }

