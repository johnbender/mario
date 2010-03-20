module Mario
  class Toolbelt
    class << self

      # Stolen shamelessly from Mitchell Hashimoto's Virtualbox gem!
      def shell_escape_path(str)
        if Platform.windows?
          #Wrap windows paths with white space in quotes
          return str =~ /\s/ ? "\"#{str}\"" : str
        end
        
        # Taken from ruby mailing list, seems to work, probably needs lots of testing :(
        str.to_s.gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').
          gsub(/\n/, "'\n'").
          sub(/^$/, "''")
        
      end
      
      # Mario would just jump to escape a shell's path
      alias_method :jump, :shell_escape_path
    end
  end
end
