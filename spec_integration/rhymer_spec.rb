require 'spec_helper'

module Creative
module Machine
module PoetEngine

  describe Rhymer do
    it "should find rhyming words" do
      Rhymer.rhyming_with('monkey').should == ["flunkey", "flunky", "chunky", "clunky", "funky", "hunky", "junkie", "junky", "punky", "spunky"]
    end    
  end

end
end
end