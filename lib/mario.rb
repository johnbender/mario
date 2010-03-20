
require 'rbconfig'
require 'logger'
lib = File.dirname(__FILE__)
%w{ mario/platform mario/toolbelt }.each { |file| require File.expand_path(file, lib) }

