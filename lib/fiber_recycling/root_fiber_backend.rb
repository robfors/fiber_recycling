module FiberRecycling
  class RootFiberBackend < FiberBackend
  
    def self.yield(*args)
      raise FiberError, "can't yield from root fiber"
    end
    
    def alive?
      ::Fiber.root.alive?
    end
    
    def inspect
      ::Fiber.root.inspect
    end
    
    def resume(*args)
      ::Fiber.root.resume(*args)
    end
    
    def to_s
      "#<RecycledFiber::Fiber:#{object_hexid}>"
    end
    
    def transfer(*args)
      ::Fiber.root.transfer(*args)
    end
    
  end
end
