module Mario
  class Platform
    @@forced = nil
    @@logger = nil
    @@current = nil

    class << self
      # TODO debatable whether cygwin should be here, initial thoughts is that it should be
      def nix_group
        [Cygwin, Linux, BSD, Solaris, Darwin]
      end
      
      def windows_group
        [Windows7, WindowsNT]
      end

      # A hash of os target internel names and partial strings that will be checked against Config::CONFIG['target_os']
      # 
      # @return [Hash]
      def targets
        nix_group + windows_group
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
      
      def bsd?
        check BSD
      end
      
      def cygwin?
        check Cygwin
      end

      def windows7?
        check Windows7
      end
      
      def windowsnt?
        check WindowsNT
      end

      def nix?
        check_group nix_group
      end

      def windows?
        check_group windows_group
      end

      def check_group(group)
        group.each do |klass|
          return klass if check klass
        end
        false
      end

      alias_method :osx?, :darwin?

      def os
        @@forced.target || Config::CONFIG['target_os']
      end

      def check(klass)
        os.downcase.include?(klass.target)
      end

      def forced=(klass)
        @@current=nil
        @@forced=klass
        logger.warn(<<-msg)
Mario::Platform.os will now report as '#{os}' and #{klass} will be used for all functionality including operating system checks and hat based functionality (See Mario::Hats for more information)
msg

      end
      
      def forced
        @@forced
      end

      def logger(out=STDOUT)
        @@logger ||= Logger.new(out)
        @@logger
      end

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
