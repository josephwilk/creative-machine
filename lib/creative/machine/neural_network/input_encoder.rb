module Creative::Machine::NeuralNetwork
  class InputEncoder
  
    class << self
      def convert(poem)
        poem.syllables.map{ |syllable| SyllableEncoder.encode(syllable) }
      end
    end
      
  end
end