module FiberRecycling
  class Fiber
  
    def self.current
      Thread.current[:fiber_recycling__fiber] || root
    end
    
    def self.root
      unless Thread.current.thread_variable_get(:fiber_recycling__root_fiber)
        Thread.current.thread_variable_set(:fiber_recycling__root_fiber, new(RootFiberBackend.new))
      end
      Thread.current.thread_variable_get(:fiber_recycling__root_fiber)
    end
    
    def self.root?
      current == root
    end
    
    def self.yield(*args)
      current.backend.class.yield(*args)
    end
    
    attr_reader :backend
    
    def initialize(backend = nil, &block)
      if backend && backend.is_a?(FiberBackend)
        @backend = backend
      else
        raise ArgumentError, 'must pass a block' unless block_given?
        @backend = NormalFiberBackend.new(self, block)
      end
    end
    
    def alive?
      @backend.alive?
    end
    
    def inspect
      to_s
    end
    
    def resume(*args)
      @backend.resume(*args)
    end
    
    def to_s
      @backend.to_s
    end
    
    def transfer(*args)
      @backend.transfer(*args)
    end
    
    def variables
      @backend.variables
    end
    
  end
end
