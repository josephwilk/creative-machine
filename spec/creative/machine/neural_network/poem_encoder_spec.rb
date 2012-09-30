require 'spec_helper'

module Creative
module Machine
module PoetEngine
module NeuralNetwork
  
  describe PoemEncoder do
    describe ".encode" do
      
      let(:lexicon) { Lexicon.new }
      
      let(:poem) do
        Haiku.new([[%W{on the cherry glass}],
                   [%W{even worn lost rain of all}],
                   [%W{and it looks not the}]])
      end
    
      it "should return 77 bit binary number" do
        encoder = PoemEncoder.new(lexicon)
        
        code = encoder.encode(poem)
      
        code[0].should have(77).bits
        (code[0] - [0] - [1]).should be_empty
      end
      
      it "should encode the index of the word in the lexicon" do
        encoder = PoemEncoder.new(lexicon)
        
        code = encoder.encode(poem)
      
        code[0][0..10].should == [0] + binary_list(619)
      end
      
      it "should encode the phonems of a syllable" do
        encoder = PoemEncoder.new(lexicon)
        
        code = encoder.encode(poem)
      
        pending "encode phonems"
        
        [["AA1", "N"]]
      end
      
      def binary_list(number)
        number.to_s(2).split('').map(&:to_i)
      end
            
    end
  end

end  
end
end
end
