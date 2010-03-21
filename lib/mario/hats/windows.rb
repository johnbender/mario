module Mario
  module Hats
    module Windows
      # Escapes a file paths for use in system calls and execute statements
      # @param [String]
      # @return [String]
      def shell_escape_path(str)
        #Wrap windows paths with white space in quotes
        str =~ /\s/ ? "\"#{str}\"" : str
      end
    end
  end
end
