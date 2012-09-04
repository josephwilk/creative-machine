module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class SyllableEncoder
          VOWELS = %W{a e i o u}
          CONSONANTS = ('a'..'z').to_a - VOWELS

          BITS_FOR_LEXICON_INDEX = 11

          class << self

            def encode(syllable, word_index_within_lexicon)
              ([1] * 66) + to_binary(word_index_within_lexicon)
            end
        
            private
        
            def to_binary(integer)
              zero_pad(integer.to_s(2)).
              split('').
              map{|x| x.to_i}
            end
        
            def zero_pad(input)
            	pad_length = BITS_FOR_LEXICON_INDEX - input.length
            	"0" * pad_length + input
            end
        
            def encode_consonant(constant)
              code = CONSONANTS.index(constant)
              code.to_s(2)
            end
  
            def encode_vowl(vowel)
              code = VOWELS.index(vowel)
              code.to_s(2)
            end
        
          end
        end

      end
    end
  end
end