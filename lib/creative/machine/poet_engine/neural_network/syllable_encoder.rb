require 'creative/machine/poet_engine/phonems'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class SyllableEncoder
          BITS_FOR_SYLLABLES = 66
          SYLLABLE_BITS = PoemEncoder::BITS_FOR_LEXICON_INDEX+1..BITS_FOR_SYLLABLES
          
          def initialize
            @phonem_encoder = PhonemEncoder.new
          end
          
          def encode(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
             
            phonemes_list = Lexicon.phonemes_for(word)
            if syllable_count == 1
              syllable_code = phonemes_list.flatten.reduce([]) {|code, phone| code << @phonem_encoder.encode(phone) }
              pad(syllable_code.flatten, BITS_FOR_SYLLABLES)
            else
              [0] * BITS_FOR_SYLLABLES
            end
          end
          
          private
          
          def pad(input, size)
            pad_length = size - input.length
            pad_length > 0 ? ([0] * pad_length) + input : input
          end
          
        end
        
      end
    end
  end
end
