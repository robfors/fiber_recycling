require 'pry'

Thread::abort_on_exception = true

require_relative "../lib/fiber_recycling.rb"

#binding.pry



#fiber = FiberRecycling::Fiber.new do
  #FiberRecycling::Fiber.yield 1
  #2
#end

#puts fiber.resume
#puts fiber.resume
#puts fiber.resume



fiber = FiberRecycling::Fiber.new do |first|
  second = FiberRecycling::Fiber.yield first + 2
end

puts fiber.resume 10
puts fiber.resume 14
puts fiber.resume 18






fiber1 = FiberRecycling::Fiber.new do
  puts "In Fiber 1"
  FiberRecycling::Fiber.yield
end

fiber2 = FiberRecycling::Fiber.new do
  puts "In Fiber 2"
  fiber1.transfer
  puts "Never see this message"
end

fiber3 = FiberRecycling::Fiber.new do
  puts "In Fiber 3"
end

fiber2.resume
fiber3.resume









puts 'done'
