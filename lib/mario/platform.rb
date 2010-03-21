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
        [Cygwin, Linux, BSD, Solaris, Darwin]
      end
      
      # A list of windows operating system classes
      #
      # @return [Array[Class]]
      def windows_group
        [Windows7, WindowsNT]
      end

      # The union of the {nix_group} and {windows_group} operating system class sets
      # 
      # @return [Array[Class]]
      def targets
        nix_group | windows_group
      end

      # Checks if the current platform is linux
      # 
      # @return [true, false]
      def linux? 
        check Linux
      end
      
      # Checks if the current platform is osx
      # 
      # @return [true, false]
      def darwin?
        check Darwin
      end

      # Checks if the current platform is solaris
      # 
      # @return [true, false]
      def solaris?
        check Solaris
      end

      # Checks if the current platform is bsd
      #
      # @return [true, false]
      def bsd?
        check BSD
      end
      
      # Checks if the current platform is cygwin
      #
      # @return [true, false]
      def cygwin?
        check Cygwin
      end

      # Checks if the current platform is windows 7
      #
      # @return [true, false]
      def windows7?
        check Windows7
      end
      
      # Checks if the current platform is windows nt
      #
      # @return [true, false]
      def windowsnt?
        check WindowsNT
      end

      # Checks if the current platform is part of the {nix_group} and returns that class
      #
      # @return [Class]
      def nix?
        check_group nix_group
      end

      # Checks if the current platform is part of the {windows_group} and returns that class
      #
      # @return [Class]
      def windows?
        check_group windows_group
      end

      # Checks a list of possible operating system classes to see if their target os strings match the {target_os} value
      #
      # @return [Class]
      def check_group(group)
        group.each do |klass|
          return klass if check klass
        end
        false
      end

      alias_method :osx?, :darwin?

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
Mario::Platform.target_os will now report as '#{target_os}' and #{klass} will be used for all functionality including operating system checks and hat based functionality (See Mario::Hats for more information)
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
        @@current ||= current_target_klass.new
        @@current
      end
    end

    # Any additional fucniontality and they should be moved to a lib/platforms/<OS>.rb
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
  end
end
