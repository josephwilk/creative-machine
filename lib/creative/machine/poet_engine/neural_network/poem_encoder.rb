require 'creative/machine/poet_engine/phonemes'
require 'creative/machine/poet_engine/neural_network/binary_helper'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PoemEncoder
          include BinaryHelper

          class PoemEncodingFailure < Exception; end

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
            raise PoemEncodingFailure.new("Cannot encode a word [#{word}] which is not in the lexicon") unless index
            index_binary = to_binary(index)
            pad(index_binary, BITS_FOR_LEXICON_INDEX)
          end

        end
  
      end
    end    
  end
end