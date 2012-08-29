require 'spec_helper'

module Creative
module Machine
  
  describe Poet do
    it "should create creative poems" do
      poet = Creative::Machine::Poet.new
      poems = poet.evolve()
      puts poems
    end
  end
  
end
end