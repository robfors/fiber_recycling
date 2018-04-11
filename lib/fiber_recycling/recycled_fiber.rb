module FiberRecycling
  class RecycledFiber
  
    def self.yield(*args)
      NativeFiber.yield(*args)
    end
    
    def initialize
      @native_fiber = NativeFiber.new { execution_loop }
      @state = :initialized
      start
    end
    
    def close
      raise 'can not close, currently running a block' unless @state == :waiting_for_instruction
      @native_fiber.resume(:close)
      nil
    end
    
    def run(*args, &block)
      raise 'can not run, already running a block' unless @state == :waiting_for_instruction
      @native_fiber.resume(:run)
      @native_fiber.resume(args)
      block_reutrn_value = @native_fiber.resume(block)
      block_reutrn_value
    end
    
    def execution_loop
      last_reutrn_value = nil
      loop do
        @state = :waiting_for_instruction
        instruction = NativeFiber.yield(last_reutrn_value)
        case instruction
        when :run
          @state = :executing_block
          args = NativeFiber.yield
          proc = NativeFiber.yield
          last_reutrn_value = proc.call(*args)
        when :close
          @state = :closed
          break
        else
          raise 'invalid instruction'
        end
      end
    end
    
    def resume(*args)
      raise 'can not resume, not running a block' unless @state == :executing_block
      @native_fiber.resume(*args)
    end
    
    def transfer(*args)
      raise 'can not transfer, not running a block' unless @state == :executing_block
      @native_fiber.transfer(*args)
    end
    
    private
    
    def start
      @native_fiber.resume
      nil
    end
  
  end
end
