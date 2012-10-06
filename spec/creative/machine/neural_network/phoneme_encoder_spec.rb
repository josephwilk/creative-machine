require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork
  
  describe PhonemeEncoder do
    describe ".encode" do

      it "should encode a phoneme with 13 bits" do
        encoder = PhonemeEncoder.new
        
        code = encoder.encode('AH1')
        
        code.should have(13).bits
      end
      
      context "with a bad phoneme" do
        it "should raise an error" do
          encoder = PhonemeEncoder.new
        
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
