require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork
  
  describe SyllableEncoder do
    describe ".encode" do

      it "should encode a syllable with 66 bits" do
        encoder = SyllableEncoder.new
        
        code = encoder.encode('on','on', 0)
        
        code.should have(66).bits
      end
            
    end
  end

end  
end
end
end
