require 'helper'

class TestNixHat < Test::Unit::TestCase
  context "Mario's Nix Hat" do
    setup do
      Mario::Platform.forced = Mario::Platform::Linux
    end
    
    should "escape weird characters in paths meant for a shell command " do
      %w( $ @ % ^ & * ).each do |char|
        assert Mario::Platform.current.shell_escape_path(char).include?('\\')
      end      
    end
  end
end
