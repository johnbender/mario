require 'helper'

class TestPlatform < Test::Unit::TestCase
  context "Mario's toolbelt" do
    context "on all platforms" do
      should "escape weird characters in paths meant for a shell command " do
        %w( $ @ % ^ & * ).each do |char|
          assert Mario::Toolbelt.shell_escape_path(char).include?('\\')
        end      
      end
    end

    context "on windows" do 
      setup do
        Mario::Platform.forced = Mario::Platform.targets[:win7]
      end

      should "wrap file paths with white space in double quotes" do
        result = Mario::Toolbelt.shell_escape_path(' something serious ')
        assert result =~ /^"/
        assert result =~ /"$/
      end
    end
  end
end
