require 'spec_helper'

module Creative
module Machine
module PoetEngine
module Evolution
  
  describe Mutator do
    let(:poem){
      Haiku.new([%W{i the cherry glass},
                %W{even worn lost rain of all},
                %W{and it looks not the}])
    }
    
    let(:lexicon){
      lexicon = PoetEngine::Lexicon.new
      lexicon.stub(:pick_word).and_return("i", "joe")
      lexicon
    }
    
    describe ".mutate" do
      context "word mutation" do
        it "should not select mutations which generate invalid a grammer in a poem" do
          Kernel.stub(:rand).and_return(0, 0, 1, 100)
        
          mutator = Mutator.new(lexicon)
      
          mutator.mutate(poem)
          
          poem.line(0).should == ["i", "joe", "cherry", "glass"]
          
        end
      end
    end
  end

end  
end
end
end
