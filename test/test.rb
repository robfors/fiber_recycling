require 'pry'

Thread::abort_on_exception = true

require_relative "../lib/recycled_fiber.rb"

#binding.pry



#fiber = RecycledFiber::Fiber.new do
  #RecycledFiber::Fiber.yield 1
  #2
#end

#puts fiber.resume
#puts fiber.resume
#puts fiber.resume



#fiber = Fiber.new do |first|
  #second = Fiber.yield first + 2
#end

#puts fiber.resume 10
#puts fiber.resume 14
#puts fiber.resume 18






fiber1 = Fiber.new do
  puts "In Fiber 1"
  Fiber.yield
end

fiber2 = Fiber.new do
  puts "In Fiber 2"
  fiber1.transfer
  puts "Never see this message"
end

fiber3 = Fiber.new do
  puts "In Fiber 3"
end

fiber2.resume
fiber3.resume









puts 'done'
