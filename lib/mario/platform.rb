module Mario
  class Platform
    @@forced = nil

    class << self
      def nix_group
        { :cygwin => 'cygwin', 
          :linux => 'linux',
          :osx => 'darwin',
          :solaris => 'solaris',
          :bsd => 'bsd'}
      end
      
      def windows_group
        { :winnt => 'mswin',
          :win7 => 'mingw' }
      end

      # A hash of os target internel names and partial strings that will be checked against Config::CONFIG['target_os']
      # 
      # @return [Hash]
      def targets
        nix_group.merge(windows_group)
      end

      # Checks if the current platform is linux
      # 
      # @return [true, false]
      def linux? 
        check_os :linux
      end
      
      # Checks if the current platform is osx
      # 
      # @return [true, false]
      def osx?
        check_os :osx 
      end

      # Checks if the current platform is solaris
      # 
      # @return [true, false]
      def solaris?
        check_os :solaris
      end
      
      def bsd?
        check_os :bsd
      end
      
      def cygwin?
        check_os :cygwin
      end

      def win7?
        check_os :win7
      end
      
      def winnt?
        check_os :winnt
      end

      def nix?
        check_group nix_group
      end

      def windows?
        check_group windows_group
      end

      def check_group(group)
        group.each do |key, value|
          return true if check_os key
        end
        false
      end

      alias_method :darwin?, :osx?

      def os
        @@forced || Config::CONFIG['target_os']
      end

      def check_os(key)
        os.downcase.include?(targets[key])
      end

      def forced=(val)
        logger.warn("Mario::Platform.os will now report as '#{val}'")
        @@forced=val
      end
      
      def forced
        @@forced
      end

      def logger(out=STDOUT)
        @@logger ||= Logger.new(STDOUT)
        @@logger
      end
    end
  end
end
