require 'helper'

class MockClass
  extend Mario::Tools
end

class AlternateMockClass
  extend Mario::Tools
end

class TestTools < Test::Unit::TestCase
  context "Mario tools" do
    setup do
      Mario::Platform.forced = Mario::Platform::Windows7
      Mario::Tools.defer_method_definition = false
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
        MockClass.platform(:windows, :baz) { true }
        MockClass.platform(:nix, :bak) {}
      end

      should "be defined correctly for the platform" do
        assert_method :baz
      end

      should "not be defined for other platforms" do
        assert_no_method :bak
      end
      
      should "not define methods on seperate classes" do
        MockClass.platform(:windows, :fik) { true }
        assert_raise NoMethodError do
          AlternateMockClass.new.fik
        end
      end
    end

    context "deferred addition of methods" do
      setup do
        Mario::Tools.defer_method_definition!
      end

      should "prevent addition of methods until explicitly requested" do
        MockClass.platform(:windows, :fiz) {}
        assert_no_method :fiz
      end

      should "add methods when called explicitly" do
        MockClass.platform(:windows, :faz) { true }
        assert_no_method :faz
        MockClass.define_platform_methods!
        assert_method :faz
      end

      should "overwrite previous methods via blocks" do
        MockClass.platform(:windows, :fink) { true }
        MockClass.platform(:linux, :fink) { false }
        assert_overwritten(:fink)
      end
      
      should "overwrite previous methods" do
        MockClass.platform(:windows) { def fizzle; true; end }
        MockClass.platform(:linux) { def fizzle; false; end }
        assert_overwritten(:fizzle)
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

  def assert_overwritten(method)
    Mario::Platform.forced = Mario::Platform::Windows7
    MockClass.define_platform_methods!
    assert MockClass.new.send(method)
    Mario::Platform.forced = Mario::Platform::Linux
    MockClass.define_platform_methods!
    assert !MockClass.new.send(method)
  end
end
