require 'helper'

class MockClass
  extend Mario::Tools
end

class TestTools < Test::Unit::TestCase
  context "Mario tools" do
    setup do
      Mario::Platform.forced = Mario::Platform::Windows7
    end

    context "platform specific instance methods" do
      setup do
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
        assert_method :foo
      end

      should "not be defined for other platforms" do
        assert_no_method :bar
      end
    end

    context "platform specific instance methods from blocks" do
      setup do
        MockClass.platform :windows, :baz do
          true
        end

        MockClass.platform :nix, :bak do
          true
        end
      end

      should "be defined correctly for the platform" do
        assert_method :baz
      end

      should "not be defined for other platforms" do
        assert_no_method :bak
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

  def assert_method(method)
    assert MockClass.new.send(method)
  end

  def assert_no_method(method)
    assert_raise NoMethodError do
      MockClass.new.send(method)
    end
  end
end
