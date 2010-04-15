require 'helper'

class MockClass
  extend Mario::Tools
end

class TestTools < Test::Unit::TestCase
  context "Mario tools" do
    context "platform specific instance methods" do
      setup do
        Mario::Platform.forced = Mario::Platform::Windows7

        MockClass.platform :windows do
          def foo
            true
          end
        end

        MockClass.platform :nix do
          def bar
            true
          end
        end
      end

      should "be defined correctly for the platform" do
        assert MockClass.new.foo
      end

      should "not be defined for other platforms" do
        assert_raise NoMethodError do
          MockClass.new.bar
        end
      end
    end

    context "platform value maps" do
      should "return the value associated with the given platform" do
        map = { :windows => true, :nix => false }
        Mario::Platform.forced = Mario::Platform::Windows7
        assert MockClass.platform_value_map(map)
        Mario::Platform.forced = Mario::Platform::Darwin
        assert !MockClass.platform_value_map(map)
      end
    end
  end
end
