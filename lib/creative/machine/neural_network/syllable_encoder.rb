module Creative
  module Machine
    module NeuralNetwork

      class SyllableEncoder
        VOWELS = %W{a e i o u}
        CONSONANTS = ('a'..'z').to_a - VOWELS
             
        class << self
          def encode(syllable)
            [1] * 77
          end
        
          private
        
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