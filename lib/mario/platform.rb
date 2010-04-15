module Mario
  class Platform
    @@forced = nil
    @@logger = nil
    @@current = nil

    class << self
      
      # A list of unix like operating system classes
      #
      # @return [Array[Class]]
      def nix_group
        [Cygwin, Linux, BSD, Solaris] + darwin_group
      end
      
      # A list of windows operating system classes
      #
      # @return [Array[Class]]
      def windows_group
        [Windows7, WindowsNT]
      end

      # A list of the different Darwin Versions
      #
      # @return [Array[Class]]
      def darwin_group
        # NOTE ordering required, but removal of Darwin class constant
        # procludes forcing os as Darwin
        [Tiger, Leopard, SnowLeopard, Darwin]
      end

      # The union of the {nix_group} and {windows_group} operating system class sets, each operating system
      # test method ( ie linux? ) is built from this set of class constants
      # 
      # @return [Array[Class]]
      def targets
        nix_group | windows_group
      end

      # Checks if the current platform is part of the {nix_group} and returns that class
      #
      # @return [Class]
      def nix?
        check_group(nix_group)
      end

      # Checks if the current platform is part of the {windows_group} and returns that class
      #
      # @return [Class]
      def windows?
        check_group(windows_group)
      end

      # Checks if the current platform is part of the {darwin_group} and returns that class
      # 
      # @return [Class]
      def darwin?
        check_group(darwin_group)
      end

      # Checks a list of possible operating system classes to see if their target os strings match the {target_os} value
      #
      # @return [Class]
      def check_group(group)
        group.each do |klass|
          return klass if check(klass)
        end
        false
      end

      # Uses the forced class target os string if provided otherwise uses the target_os rbconfig hash element
      #
        # @return [String]
      def target_os
        @@forced ? @@forced.target : Config::CONFIG['target_os']
      end

      # Checks an os class against {target_os}
      #
      # @return [true, false]
      def check(klass)
        target_os.downcase.include?(klass.target)
      end

      # Allows the user to force Mario to report the operating system as one of the provided operatin system classes
      #
      def forced=(klass)
        @@current=nil
        @@forced=klass
        logger.warn(<<-msg)
Mario::Platform.target_os will now report as '#{target_os}' and #{klass} will be used for all functionality including operating system checks, platform blocks, and hat based functionality
msg
      end
      
      # Returns the value of the currently forced operating system class if any
      #
      # @return [Class]
      def forced
        @@forced
      end

      # Allows the setting of a logging mechanism, defaults to STDOUT
      #
      # @return [Logger]
      def logger(out=STDOUT)
        @@logger ||= Logger.new(out)
        @@logger
      end

      # Returns an instance of the current operating system class as determined by {check_group} against all operating
      # system classes provided by {targets}
      #
      # @return [OperatingSystem]
      def current
        # Search for the current target os
        current_target_klass = check_group(targets)
        unless current_target_klass
          raise OperatingSystemNotRecognized.new(<<-msg)

The current target os #{target_os}, is not recognized by Mario, please use/change Mario::Platform.forced to emulate a supported operating system."

msg
        end
        @@current ||= current_target_klass.new
        @@current
      end

      def klass_to_method(klass)
        klass.to_s.downcase.split('::').last
      end
      
      def check_symbol(name)
        send(name.to_s + '?')
      end
    end

    # NOTE Any additional functionality and they should be moved to a lib/platforms/<OS>.rb
    class Cygwin
      include Hats::Nix
      
      def self.target
        'cygwin'
      end
    end

    class Darwin    
      include Hats::Nix

      def self.target 
        'darwin'
      end
    end

    class Leopard < Darwin
      def self.target
        super + "9"
      end
    end

    class Tiger < Darwin
      def self.target
        super + "8"
      end
    end

    class SnowLeopard < Darwin
      def self.target
        super + "10"
      end
    end

    class Linux
      include Hats::Nix

      def self.target
        'linux'
      end
    end

    class BSD
      include Hats::Nix
  
      def self.target
        'bsd'
      end
    end

    class Solaris
      include Hats::Nix

      def self.target
        'solaris'
      end
    end

    class Windows7
      include Hats::Windows

      def self.target
        'mingw'
      end
    end

    class WindowsNT
      include Hats::Windows

      def self.target
        'mswin'
      end
    end

    targets.each do |klass|
      define_class_method(klass_to_method(klass) + '?') do
        check(klass)
      end
    end

    class OperatingSystemNotRecognized < Exception; end
  end
end
