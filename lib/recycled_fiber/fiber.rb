module RecycledFiber
  class Fiber
  
    def self.current
      Thread.current[:recycled_fiber]
    end
    
    def self.yield(*args)
      @state = 'suspended'
      RecycledFiber.yield(*args)
      @state = 'resumed'
    end
    
    def initialize(&block)
      raise ArgumentError, 'must pass a block' unless block_given?
      @state = 'created'
      @recycled_fiber = RecycledFiberPool.local.release_recycled_fiber
      @recycled_fiber.run { execute(block) }
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
    
    def execute(block)
      args = RecycledFiber.yield
      Thread.current[:recycled_fiber] = self
      return_value = block.call(*args)
      Thread.current[:recycled_fiber] = nil
      @state = 'terminated'
      RecycledFiberPool.local.absorb_recycled_fiber(@recycled_fiber)
      return_value
    end
    
  end
end
