module Mario
  class Toolbelt
    class << self

      # Stolen shamelessly from Mitchell Hashimoto's Virtualbox gem!
      # TODO more research
      def shell_escape_path(str)
        if Platform.windows?
          #Wrap windows paths with white space in quotes
          str = "\"#{str}\"" if str =~ /\s/
          return str
        end
        
        str.to_s.gsub(/(?=[^a-zA-Z0-9_.\/\-\x7F-\xFF\n])/n, '\\').
          gsub(/\n/, "'\n'").
          sub(/^$/, "''")
      end
      
      # Mario would just jumpt to escape a shell's path
      alias_method :jump, :shell_escape_path
      
    end
  end
end
