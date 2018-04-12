# FiberRecycling
This Ruby Gem offers a duck type for `Fiber` that will reuse old native fibers for a small performance gain. It will work as a drop in replacment for Ruby's natve `Fiber`, offering a small performance gain.

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
    fiber.resume # => FiberRecycling::FiberError, dead fiber called
  end
  
end

A.a
```

# How It Works
As fibers can only be resumed in the thread that they were created, a native fiber pool will be created on demand for each thread that a pool is needed. The native fibers in each pool also only be created on demand. When a new `FiberRecycling::Fiber` is created, it will create a new native fiber if none are available in thread's pool. The native fiber will only be returned to the pool when the `FiberRecycling::Fiber` has completed executing it's block (is in a dead state). As each pool is shared globally, possibly being accessed by multiple code bases that have no knowledge of each other, it is impossible to allow a code base to set a maximum pool size limit. One project may want a maximum size of 5 native fibers per thread while another may want 10, there is no way to satisfy both requests. As such *FiberRecycling* will put no constraint on the number of native fibers that can be created. Therefore, it is important to keep in mind that *FiberRecycling* will create as many native fibers as is simoustanly demanded and will not delete them until the thread gets garbage collected (if you are creating fibers in the main thread, this will obviously never happen). It is up to the developer of the code base to ensure that only a reasonable amount of `FiberRecycling::Fiber` will ever be alive simoustanly.
