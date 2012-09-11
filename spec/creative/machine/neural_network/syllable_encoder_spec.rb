require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork

  
  describe SyllableEncoder do
    describe ".encode" do
    
      it "should return 77 bit binary number" do
        input = SyllableEncoder.encode('wa', 1)
      
        input.should have(77).bits
        (input - [0] - [1]).should be_empty
      end
            
    end
  end

end  
end
end
end
