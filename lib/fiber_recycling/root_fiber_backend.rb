module FiberRecycling
  class RootFiberBackend < FiberBackend
  
    def self.yield(*args)
      raise FiberError, "can't yield from root fiber"
    end
    
    def alive?
      NativeFiber.root.alive?
    end
    
    def inspect
      NativeFiber.root.inspect
    end
    
    def resume(*args)
      NativeFiber.root.resume(*args)
    end
    
    def to_s
      "#<RecycledFiber::Fiber:#{object_hexid}>"
    end
    
    def transfer(*args)
      NativeFiber.root.transfer(*args)
    end
    
  end
end
