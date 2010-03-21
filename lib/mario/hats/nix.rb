# Posix?
module Mario
  module Hats
    module Nix
      
      # Escapes paths for use in execute statements
      # 
      # @param [String]
      # @return [String]
      def shell_escape_path(str)
        # Taken from ruby mailing list, seems to work, probably needs lots of testing :(
        str.to_s.gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').
          gsub(/\n/, "'\n'").
        sub(/^$/, "''")
      end
    end
  end
end
