module Mario
  module Tools
    @@method_blocks = {}
    @@deferred = false

    def platform(name, method=nil, &block)
      @@method_blocks[name] = block
      define_platform_methods if !deferred
    end
    
    def platform_value_map(map={})
      map.each do |key, value|
        return value if Platform.check_symbol(key)
      end
    end
    
    def define_platform_methods
      @@method_blocks.each do |name, block|
        self.class_eval &block if Platform.check_symbol(name)
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
