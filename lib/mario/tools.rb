module Mario
  module Tools
    @@class_method_blocks = {}
    @@defer_method_definition = false

    def defer_method_definition
      @@defer_method_definition
    end

    def defer_method_definition=(val)
      @@defer_method_definition=val
    end

    def defer_method_definition!
      @@defer_method_definition=true
    end

    module_function :defer_method_definition, :defer_method_definition=, :defer_method_definition!

    def platform(name, method=nil, &block)
      @@class_method_blocks[self] ||= {}
      @@class_method_blocks[self][name] = method ? [ method , block ] : block
      define_platform_methods! unless defer_method_definition
    end

    def platform_value_map(map={})
      map.each do |key, value|
        return value if Platform.check_symbol(key)
      end
    end

    def define_platform_methods!
      @@class_method_blocks[self].each do |name, value|
        if Platform.check_symbol(name)
          if value.is_a?(Proc)
            self.class_eval &value
          else
            define_method value.first, &value.last
          end
        end
      end
    end
  end
end
