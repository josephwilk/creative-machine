module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PoemEncoder
  
          class << self
            def encode(poem)
              word_index_within_lexicon = 1
              poem.syllables.map{ |syllable| SyllableEncoder.encode(syllable, word_index_within_lexicon) }
            end
          end

        end
  
      end
    end    
  end
end