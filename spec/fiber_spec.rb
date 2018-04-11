require 'fiber_recycling'

RSpec.describe FiberRecycling::Fiber do
  
  describe "#resume" do
  
    context "when called on fiber that does not yield" do
      it "should return last value" do
        fiber = FiberRecycling::Fiber.new { 1 }
        last_value = fiber.resume
        expect(last_value).to eql 1
      end
    end
    
    context "when called for the fist time" do
      it "should use argument passed to 'resume' as block parameter" do
        fiber = FiberRecycling::Fiber.new { |a| a }
        expect(fiber.resume(1)).to eql 1
      end
      
      it "should use arguments passed to it as block parameters" do
        fiber = FiberRecycling::Fiber.new { |a, b| [a, b] }
        expect(fiber.resume(1,2)).to eql [1, 2]
      end
    end
    
    context "when called on fiber that yields" do
      it "should return argument passed to yield and 'yield' should return argument passed to 'resume'" do
        fiber = FiberRecycling::Fiber.new do |a|
          FiberRecycling::Fiber.yield(a)
        end
        expect(fiber.resume(1)).to eql 1
      end
    end
    
    context "when called on dead fiber" do
      it "should raise FiberError" do
        fiber = FiberRecycling::Fiber.new {}
        fiber.resume
        expect{ fiber.resume }.to raise_error FiberRecycling::FiberError
      end
    end
    
  end
  
  describe "::current" do
  
    context "when not in a fiber" do
      it "should return a fiber" do
        fiber = FiberRecycling::Fiber.current
        expect(fiber).to be_a(FiberRecycling::Fiber)
      end
      
      it "should return root fiber" do
        fiber = FiberRecycling::Fiber.current
        expect(fiber).to eql FiberRecycling::Fiber.root
      end
    end
    
    context "when in a fiber" do
      it "should return a fiber" do
        fiber = FiberRecycling::Fiber.new do
          FiberRecycling::Fiber.current
        end
        expect(fiber.resume).to be_a(FiberRecycling::Fiber)
      end
      
      it "should return current fiber" do
        fiber = FiberRecycling::Fiber.new do
          FiberRecycling::Fiber.current
        end
        expect(fiber.resume).to eql fiber
      end
    end
    
  end
    
  describe "::yield" do
    
    context "when called in root fiber" do
      it "should raise FiberError" do
        expect{ FiberRecycling::Fiber.yield }.to raise_error FiberRecycling::FiberError
      end
    end
    
  end
  
  describe "#alive?" do
    
    context "when called on new fiber" do
      it "should return true" do
        fiber = FiberRecycling::Fiber.new do
          FiberRecycling::Fiber.yield
        end
        expect(fiber.alive?).to eql true
      end
    end
    
    context "when called on yielded fiber" do
      it "should return true" do
        fiber = FiberRecycling::Fiber.new do
          FiberRecycling::Fiber.yield
        end
        fiber.resume
        expect(fiber.alive?).to eql true
      end
    end
    
    context "when called on completed fiber" do
      it "should return false" do
        fiber = FiberRecycling::Fiber.new {}
        fiber.resume
        expect(fiber.alive?).to eql false
      end
    end
    
  end
  
  
  describe "#transfer" do
  
    context "when called from within a fiber" do
      it "should resume the callee fiber" do
        fiber1 = FiberRecycling::Fiber.new do
          Fiber.yield(1)
        end
        
        fiber2 = Fiber.new do
          fiber1.transfer
          2
        end
        
        expect(fiber2.resume).to eql 1
      end
    end
    
  end
end
