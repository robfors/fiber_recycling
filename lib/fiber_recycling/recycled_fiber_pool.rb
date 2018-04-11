module FiberRecycling
  class RecycledFiberPool < QuackPool
    
    def self.local
      unless Thread.current.thread_variable_get(:recycled_fiber_pool)
        Thread.current.thread_variable_set(:recycled_fiber_pool, new)
      end
      Thread.current.thread_variable_get(:recycled_fiber_pool)
    end
    
    def initialize
      super(resource_class: RecycledFiber)
    end
    
    def release_recycled_fiber
      release_resource
    end
    
    def absorb_recycled_fiber(recycled_fiber)
      absorb_resource(recycled_fiber)
    end
  
  end
end
