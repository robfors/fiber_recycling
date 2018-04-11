# Ruby Gem: FiberRecycling
This gem offers a ducktype for `Fiber` that will reuse old native fibers for a small performance gain. It will work as a drop in replacment for Ruby's natve `Fiber`.

# Install
`gem install fiber_recycling`

Then simply `require 'fiber_recycling'` in your project.

# Example
`FiberRecycling::Fiber` can be used just like `::Fiber`.
```ruby
fiber = FiberRecycling::Fiber.new do |a, b|
  c = FiberRecycling::Fiber.yield(a)
  d = FiberRecycling::Fiber.yield(c + 1)
  d
end

fiber.resume(1, 2) # => 1
fiber.resume(3) # => 4
fiber.resume(5) # => 5
```

```ruby
fiber = FiberRecycling::Fiber.new do
  FiberRecycling::Fiber.yield
end

fiber.resume # => nil
fiber.resume # => nil
fiber.resume # => FiberRecycling::FiberError, dead fiber called
```

To integrate *FiberRecycling* into an existing project that relies on `Fiber` you can `include` `FiberRecycling::DuckTypes`.
```ruby
module A
  include FiberRecycling::DuckTypes
  
  def self.a
    fiber = Fiber.new do
      Fiber.yield
    end
    
    fiber # => FiberRecycling::Fiber
    fiber.resume # => nil
    fiber.resume # => nil
    fiber.resume # => FiberRecycling::FiberError, dead fiber resumed
  end
  
end

A.a
```
