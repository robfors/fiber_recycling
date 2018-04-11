require 'fiber_recycling'

RSpec.describe FiberRecycling::DuckTypes do
  
  describe FiberRecycling::Fiber do
  
    context "when creating a Fiber" do
      it "should create a FiberRecycling::Fiber" do
        module A
          include FiberRecycling::DuckTypes
          
          def self.a
            Fiber.new {}
          end
          
        end
        
        expect(A.a).to be_a(FiberRecycling::Fiber)
      end
    end
    
  end
  
  describe FiberRecycling::FiberError do
  
    context "when FiberError is raised" do
      it "should raise FiberRecycling::FiberError" do
        module A
          include FiberRecycling::DuckTypes
          
          def self.a
            fiber = Fiber.new {}
            fiber.resume
            expect{ fiber.resume }.to raise_error FiberError
          end
          
        end
      end
    end
    
  end
end
