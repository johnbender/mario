require 'helper'

class TestWindowsHat < Test::Unit::TestCase
  context "Mario's windows hat" do 
    setup do
      Mario::Platform.forced = Mario::Platform::Windows7
    end

    should "wrap file paths with white space in double quotes" do
      result = Mario::Platform.current.shell_escape_path(' something serious ')
      assert result =~ /^".+"$/
    end

    should "not have spaces escaped" do
      assert !Mario::Platform.current.shell_escape_path( 'a b' ).include?('\\')
    end
  end
end
