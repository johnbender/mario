module Mario
  module Tools
    @@method_blocks = {}
    @@deferred = false

    def platform(name, method=nil, &block)
      @@method_blocks[name] = method ? [ method , block ] : block
      define_platform_methods if !deferred
    end
    
    def platform_value_map(map={})
      map.each do |key, value|
        return value if Platform.check_symbol(key)
      end
    end
    
    def define_platform_methods
      @@method_blocks.each do |name, value|
        if Platform.check_symbol(name)
          if value.is_a?(Proc)
            self.class_eval &value 
          else
            define_method value.first, &value.last
          end
        end
      end
    end
    
    def deferred
      @@deferred
    end    
    
    def deferred=(val)
      @@deferred=val
    end

    def deferred!
      @@deferred=true
    end
  end
end
