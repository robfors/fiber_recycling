module FiberRecycling
  class RecycledFiberPoolBorrower
  
    def initialize(pool)
      @pool = pool
      @recycled_fiber = nil
    end
    
    def retrieve
      @recycled_fiber ||= @pool.release_recycled_fiber
      @recycled_fiber
    end
    
    def return
      @pool.absorb_recycled_fiber(@recycled_fiber) if @recycled_fiber
      nil
    end
    
    def returned?
      @recycled_fiber
    end
    
  end
end
