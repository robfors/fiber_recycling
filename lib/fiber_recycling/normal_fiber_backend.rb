module FiberRecycling
  class NormalFiberBackend < FiberBackend
  
    def self.yield(*args)
      @state = 'suspended'
      return_value = RecycledFiber.yield(*args)
      @state = 'resumed'
      return_value
    end
    
    def initialize(fiber, block)
      @state = 'created'
      @recycled_fiber = RecycledFiberPool.local.release_recycled_fiber
      @recycled_fiber.run { execute(fiber, block) }
    end
    
    def alive?
      @state != 'terminated'
    end
    
    def inspect
      to_s
    end
    
    def resume(*args)
      raise FiberError, 'dead fiber called' unless alive?
      @recycled_fiber.resume(*args)
    end
    
    def to_s
      "#<RecycledFiber::Fiber:#{object_hexid} (#{@state})>"
    end
    
    def transfer(*args)
      raise FiberError, 'dead fiber called' unless alive?
      @recycled_fiber.transfer(*args)
    end
    
    private
    
    def execute(fiber, block)
      args = RecycledFiber.yield
      Thread.current[:fiber_recycling__fiber] = fiber
      return_value = block.call(*args)
      Thread.current[:fiber_recycling__fiber] = nil
      @state = 'terminated'
      RecycledFiberPool.local.absorb_recycled_fiber(@recycled_fiber)
      return_value
    end
    
  end
end
