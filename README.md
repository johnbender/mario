mario
=====

Mario is super small library to help you with getting from platform to platform with ease!

platform
--------
Mario's main function is providing simple methods to match your current operating system or a group of operating systems. For example if you wanted to know if your code was excuting on some version of Windows

    Mario::Platform.windows?
    
Or a Unix-like operating system

    Mario::Platform.nix?
    
If you want to be more specific you can do that too

    Mario::Platform.bsd? # or linux? or windows7? or darwin?

If for some reason you opperating system isn't represented please alert me and/or see the setup for hacking on Mario below, but in the meantime you can force which operating system you would like Mario to report

    Mario::Platform.forced = Mario::Platform::Linux


targeted methods
----------------
In version 0.1 of Mario, the ability to define platform specific instance method implementations has been added via the class method `platform`. All you have to do is extend your class with `Mario::Tools`. 

    class MyClass
      extend Mario::Tools
  
      platform :windows do
        def foo
          "I will only work for Windows!"
        end
      end

      platform :linux do
        def foo
          "I will only work for Linux!"
        end
      end
    end

    Mario::Platform.forced = Mario::Platform::Windows7
    MyClass.new.foo # => "I will only work for Windows!"

    Mario::Platform.forced = Mario::Platform::Linux
    MyClass.new.foo # => "I will only work for Linux!"
    
Alternatively, if you don't need the flexibility of actual method definitions or multiple methods, you can do the following:

    class MyClass
      extend Mario::Tools

      platform :windows, :foo do |param|
        "This is my param on Windows: #{param}"
      end
      
      platform :linux, :foo do |param|
        "This is my param on Linux: #{param}"
      end
    end
    

platform value maps
-------------------
Sometimes you don't need an actual method and you just want to define a platform spefic value for something. With Mario you can do the following:

    class MyClass
      extend Mario::Tools
      attr_accessor :my_ivar

      def initialize
        @my_ivar = platform_value_map { :windows => 'Windows!', :linux => 'Linux!' }
      end
    end

    Mario::Platform.forced = Mario::Platform::Windows7
    MyClass.new.my_ivar # => 'Windows!'

    Mario::Platform.forced = Mario::Platform::Linux
    MyClass.new.my_ivar # => 'Linux!'

platform symbol values
----------------------
Any class defined in Mario::Platform.targets can be used as symbol for `platform` and `platform_value_map` to target a given platform. The following are supported as of version 0.1

    >> Mario::Platform.targets.map{ |t| Mario::Platform.klass_to_method(t).to_sym }
    => [:cygwin, :linux, :bsd, :solaris, :tiger, :leopard, :snowleopard, :darwin, :windows7, :windowsnt]

testing
-------
When testing your app you'll want to force the platform that mario reports to test your platform specific methods. In order to accomplish this make sure to defer the method definition done by the `platform` class method in the following manner.

    Mario::Tools.defer_method_definition!
    require 'my_class'

This will allow you to force the platform and THEN define the methods on your classes manually so that you can test them for various platforms.

    Mario::Platform.forced = Mario::Platform::Windows7
    MyClass.define_platform_methods!
    MyClass.new.foo # => "Windows!"

The blocks are stored so that `define_platform_methods!` can be called many times after forcing the platform to provide different results.

    Mario::Platform.forced = Mario::Platform::Windows7
    MyClass.define_platform_methods!
    MyClass.new.foo # => "Windows!"

    Mario::Platform.forced = Mario::Platform::Linux
    MyClass.define_platform_methods!
    MyClass.new.foo # => "Linux!"

*IMPORTANT* The above does NOT apply to `platform_value_map`, if you want the above functionality its best to assign the values from functions defined in the above manner

hats
----
Mario has different abilities with different hats, each hat is tied to the current operating system. To start Mario can only escape file paths properly for nix operating systems and there's still testing to be done on the windows version, but there will be more to come. To make use of Mario's version of his abilities on your platform you might do the following:

    Mario::Platform.current.shell_escape_path('C:\Some Path\With Some Spaces.filext')

Its important to note that shell_escape_path is an actual method and not what Mario would do when confronted with an oncoming koopa shell.

hacking
-------

If you want to hack on mario, and I would grateful for any patches to for all those dark little corners that need light shone on them, just do the following from your project directory after forking and cloning:

    $ bundle install
    $ bundle lock
    $ rake test
    
If all is well you're ready to roll.

license
-------

See the license file for more information.
