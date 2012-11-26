require 'creative/machine/poet_engine/phonemes'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PoemEncoder
          BITS_FOR_LEXICON_INDEX = 11
          LEXICON_BITS = 0..BITS_FOR_LEXICON_INDEX-1
          
          def initialize(lexicon = Lexicon.new)
            @lexicon = lexicon
            @syllable_encoder = SyllableEncoder.new
          end

          def encode(poem)
            poem.words.reduce([]) {|binary_poem, word| binary_poem = binary_poem + encode_word(word)}
          end
          
          private
          
          def encode_word(word)
            lexicon_index_in_binary = binary_lexicon_word_code(word)
            Lexicon.syllables_in(word).each_with_index.map {|syllable, syllable_index| 
              lexicon_index_in_binary + @syllable_encoder.encode(word, syllable, syllable_index)
            }
          end
          
          def binary_lexicon_word_code(word)
            index = @lexicon.index(word)
            raise Exception.new("Cannot find word in lexicon: #{word}") unless index
            index_binary = to_binary(index)
            pad(index_binary, BITS_FOR_LEXICON_INDEX)
          end
          
          def pad(input, size)
            pad_length = size - input.length
            pad_length > 0 ? ([0] * pad_length) + input : input
          end
          
          def to_binary(number)
            number.to_i.to_s(2).split('').map(&:to_i)
          end

        end
  
      end
    end    
  end
end