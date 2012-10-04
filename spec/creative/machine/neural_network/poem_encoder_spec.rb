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
      
      context "with a one syllable word" do
        let(:encoded_word) do 
          encoder = PoemEncoder.new(lexicon)
          code = encoder.encode(poem)[0]
        end
      
        it "should encode the index of the word in the lexicon" do
          encoded_word[PoemEncoder::LEXICON_BITS].should == [0] + binary_list(617)
        end
        
        it "should encode the phonems of the syllable" do
          phones = [["AA1", "N"]]
        
          encoded_word[PoemEncoder::SYLLABLE_BITS].should == [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1]
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
end
