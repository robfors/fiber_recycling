module FiberRecycling
  module ThreadExtensions
  
    def [](key)
      if key == :fiber_recycling__fiber || Fiber.root?
        super
      else
        Fiber.current.variables[key]
      end
    end
    
    def []=(key, value)
      if key == :fiber_recycling__fiber || Fiber.root?
        super
      else
        Fiber.current.variables[key] = value
      end
    end
    
  end
end  
