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
            poem.words.reduce([]) {|binary_poem, word| binary_poem + encode_word(word)}
          end
          
          def encode_word(word)
            lexicon_index_in_binary = binary_lexicon_word_code(word)
            Lexicon.syllables_in(word).each_with_index.map{|syllable, syllable_index| lexicon_index_in_binary + encode_syllable(word, syllable, syllable_index)}
          end
          
          def encode_syllable(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
             
            phonemes = Lexicon.phonemes_for(word)
            puts phonemes.inspect
            
            if syllable_count == 1
              phonemes
            end

            #TODO: identify which phonems are associated with this syllable.
            
            [0] * 67
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