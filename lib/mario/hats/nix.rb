# Posix?
module Mario
  module Hats
    module Nix
      def shell_escape_path(str)
        # Taken from ruby mailing list, seems to work, probably needs lots of testing :(
        str.to_s.gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').
          gsub(/\n/, "'\n'").
        sub(/^$/, "''")
      end
    end
  end
end
