begin
  require File.expand_path('../.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

begin
  require 'ruby-debug'
rescue LoadError; end

require File.join(File.dirname(__FILE__), '..', 'lib', 'mario')
require 'test/unit'
require 'mocha'
require 'shoulda'

class Test::Unit::TestCase
  def setup
    logger = mock('logger')
    Mario::Platform.stubs(:logger).returns(logger)
    logger.stubs(:warn)
  end
end

    
