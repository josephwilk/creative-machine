require File.dirname(__FILE__) + '/spec_helper'

module Creative
module Machine
  
  describe Poet do
    it "should create creative poems" do
      poet = Creative::Machine::Poet.new
      poems = poet.evolve()
    end
  end
  
end
end