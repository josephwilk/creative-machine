module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PoemEncoder
          BITS_FOR_LEXICON_INDEX = 11
          
          def initialize(lexicon)
            @lexicon = lexicon
          end

          def encode(poem)
            poem.words.map {|word| encode_word(word)}
          end
          
          def encode_word(word)
            binary_lexicon_word_code(word) + [0] * 67
          end
          
          def binary_lexicon_word_code(word)
            index = @lexicon.index(word)
            raise Exception.new("Cannot find word in lexicon: #{word}") unless index
            index_binary = pad(index.to_s(2))
            index_binary.split('').map(&:to_i)
          end
          
          def pad(input)
            pad_length = BITS_FOR_LEXICON_INDEX - input.length
            "0" * pad_length + input
          end

        end
  
      end
    end    
  end
end