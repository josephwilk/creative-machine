module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class InputEncoder
  
          class << self
            def convert(poem)
              #TODO: syllables should know their word index within lexicon
              word_index_within_lexicon = 1
              poem.syllables.map{ |syllable| SyllableEncoder.encode(syllable, word_index_within_lexicon) }
            end
          end

        end
  
      end
    end    
  end
end