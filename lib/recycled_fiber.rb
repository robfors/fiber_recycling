require 'thread'
require 'fiber'
require 'quack_pool'

require_relative "recycled_fiber/fiber.rb"
require_relative "recycled_fiber/recycled_fiber.rb"
require_relative "recycled_fiber/recycled_fiber_pool.rb"

module RecycledFiber

  NativeFiber = ::Fiber

end
