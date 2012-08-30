require 'spec_helper'

module Creative
module Machine
module NeuralNetwork
  
  describe SyllableEncoder do
    describe ".encode" do
    
      it "should return 77 bit binary number" do
        input = SyllableEncoder.encode('wa')
      
        input.should have(77).bits
      end
      
      it "should encode the syllable somehow..."
      
    end
  end

end  
end
end
