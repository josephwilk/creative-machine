require 'creative/machine/poet_engine/phonems'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PoemEncoder
          BITS_FOR_LEXICON_INDEX = 11
          BITS_FOR_SYLLABLES = 66
          
          LEXICON_BITS = 0..BITS_FOR_LEXICON_INDEX-1
          SYLLABLE_BITS = BITS_FOR_LEXICON_INDEX+1..BITS_FOR_SYLLABLES
          
          def initialize(lexicon)
            @lexicon = lexicon
          end

          def encode(poem)
            poem.words.reduce([]) {|binary_poem, word| encode_word(word)}
          end
          
          def encode_word(word)
            lexicon_index_in_binary = binary_lexicon_word_code(word)
            Lexicon.syllables_in(word).each_with_index.map {|syllable, syllable_index| 
               encode_syllable(word, syllable, syllable_index)
            }.
            map{|syllable| lexicon_index_in_binary + syllable}
          end
          
          def encode_syllable(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
             
            phonemes = Lexicon.phonemes_for(word)
            if syllable_count == 1
              code = encode_phonemes(phonemes[0]).flatten.join
              code = pad(code, BITS_FOR_SYLLABLES)
              code.split('')
            else
              [[0] * BITS_FOR_SYLLABLES]
            end
          end
          
          # 1st bit represents the parameter of consonant/vowel
          # 2nd bit represents the parameter of voiced/voiceless
          # 3rd-5th bits represent the seven possible places of articulation
          # 6th-8th bits represent the seven possible manners of articulation
          # 9th,10th,11th bits represent the five possible heights
          # 12th, 13th bits represent the three possible depths
          def encode_phonemes(phonemes)
            phonemes.map do |phone| 
              phone_data = Phonems.lookup(phone)
              bit_1 = phone['manner'] == 'vowel' ? 0 : 1
              
              [bit_1] + [0] * 12
            end
          end
          
          def binary_lexicon_word_code(word)
            index = @lexicon.index(word)
            raise Exception.new("Cannot find word in lexicon: #{word}") unless index
            index_binary = pad(index.to_s(2), BITS_FOR_LEXICON_INDEX)
            index_binary.split('').map(&:to_i)
          end
          
          def pad(input, size)
            pad_length = size - input.length
            "0" * pad_length + input
          end

        end
  
      end
    end    
  end
end