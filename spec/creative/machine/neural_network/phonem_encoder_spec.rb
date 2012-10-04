require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork
  
  describe PhonemEncoder do
    describe ".encode" do

      it "should encode a phonem with 13 bits" do
        encoder = PhonemEncoder.new
        
        code = encoder.encode('AH1')
        
        code.should have(13).bits
      end
      
      context "with a bad phonem" do
        it "should raise an error" do
          encoder = PhonemEncoder.new
        
          lambda{
            code = encoder.encode('MOOOOOOOOOOOO')
          }.should raise_error(InvalidPhone)
        
          
        end
      end
            
    end
  end

end  
end
end
end
