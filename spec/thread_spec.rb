require 'fiber_recycling'

RSpec.describe Thread do

  context "when calling native method" do
    it "should work" do
      expect(Thread.current.alive?).to eql true
    end
  end
  
  context "when in root FiberRecycling::Fiber" do
    
    context "when setting a variable" do
      it "should persist" do
        Thread.current[:a] = 1
        expect(Thread.current[:a]).to eql 1
      end
    end
    
    context "when setting a variable" do
      it "should not exist in FiberRecycling::Fiber" do
        Thread.current[:a] = 1
        fiber = FiberRecycling::Fiber.new do
          Thread.current[:a]
        end
        expect(fiber.resume).to eql nil
      end
    end
    
    context "when setting a variable" do
      it "should should persist a new FiberRecycling::Fiber" do
        Thread.current[:a] = 1
        fiber = FiberRecycling::Fiber.new do
          Thread.current[:a] = 2
        end
        fiber.resume
        expect(Thread.current[:a]).to eql 1
      end
    end
    
  end
  
  context "when in non root FiberRecycling::Fiber" do
    
    context "when getting a variable" do
      it "should not exist outside FiberRecycling::Fiber" do
        Thread.current[:a] = nil
        fiber = FiberRecycling::Fiber.new do
          Thread.current[:a] = 1
        end
        fiber.resume
        expect(Thread.current[:a]).to eql nil
      end
    end
    
    context "when setting a variable" do
      it "should persist a yield" do
        Thread.current[:a] = nil
        fiber = FiberRecycling::Fiber.new do
          Thread.current[:a] = 1
          FiberRecycling::Fiber.yield
          Thread.current[:a]
        end
        fiber.resume
        Thread.current[:a] = 2
        expect(fiber.resume).to eql 1
      end
    end
    
    context "when setting a variable" do
      it "should not leak to next fiber" do
        Thread.current[:a] = nil
        fiber1 = FiberRecycling::Fiber.new do
          Thread.current[:a] = 1
        end
        fiber1.resume
        fiber2 = FiberRecycling::Fiber.new do
          Thread.current[:a]
        end
        expect(fiber2.resume).to eql nil
      end
    end
    
  end
end
