require 'thread'
require 'fiber'
require 'quack_pool'

require_relative "fiber_recycling/fiber.rb"
require_relative "fiber_recycling/recycled_fiber.rb"
require_relative "fiber_recycling/recycled_fiber_pool.rb"

module FiberRecycling

  NativeFiber = ::Fiber

end
