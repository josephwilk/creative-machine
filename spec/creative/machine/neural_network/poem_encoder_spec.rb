require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork
  
  describe PoemEncoder do
    describe ".encode" do
      
      let(:lexicon) { Lexicon.new }
      
      let(:poem) do
        Haiku.new([['on the cherry glass'],
                  ['even worn lost rain of all'],
                  ['and it looks not the']])
      end
    
      it "should return 77 bit binary number" do
        encoder = PoemEncoder.new(lexicon)
        
        code = encoder.encode(poem)
      
        code.should have(77).bits
        (code - [0] - [1]).should be_empty
      end
            
    end
  end

end  
end
end
end
