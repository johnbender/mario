module Mario
  module Hats
    module Windows
      def shell_escape_path(str)
        #Wrap windows paths with white space in quotes
        str =~ /\s/ ? "\"#{str}\"" : str
      end
    end
  end
end
