
require 'rbconfig'
require 'logger'
lib = File.dirname(__FILE__)
%w{  mario/hats/nix mario/hats/windows mario/platform }.each { |file| require File.expand_path(file, lib) }

