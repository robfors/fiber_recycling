module FiberRecycling
  class NormalFiberBackend < FiberBackend
  
    def self.finalizer(recycled_fiber_borrower)
      Proc.new { recycled_fiber_borrower.return }
    end
    
    def self.yield(*args)
      @state = 'suspended'
      return_value = RecycledFiber.yield(*args)
      @state = 'resumed'
      return_value
    end
    
    attr_reader :variables
    
    def initialize(fiber, block)
      @state = 'created'
      @variables = {}
      @recycled_fiber_borrower =  RecycledFiberPool.local.borrower
      @recycled_fiber = @recycled_fiber_borrower.retrieve
      @recycled_fiber.run { execute(fiber, block) }
      ObjectSpace.define_finalizer(self, self.class.finalizer(@recycled_fiber_borrower))
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
      @recycled_fiber = nil
      @recycled_fiber_borrower.return
      return_value
    end
    
  end
end
