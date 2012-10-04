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
          
          ARTICULATIONS = %W{fricative vowel stop liquid nasal affricate aspirate}
          
          def initialize(lexicon)
            @lexicon = lexicon
          end

          def encode(poem)
            poem.words.reduce([]) {|binary_poem, word| binary_poem = binary_poem + encode_word(word)}
          end
          
          private
          
          def encode_word(word)
            lexicon_index_in_binary = binary_lexicon_word_code(word)
            Lexicon.syllables_in(word).each_with_index.map {|syllable, syllable_index| 
              lexicon_index_in_binary + encode_syllable(word, syllable, syllable_index)
            }
          end
          
          def encode_syllable(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
             
            phonemes = Lexicon.phonemes_for(word)
            if syllable_count == 1
              code = encode_phonemes(phonemes[0]).flatten
              pad(code, BITS_FOR_SYLLABLES)
            else
              [0] * BITS_FOR_SYLLABLES
            end
          end
          
          # 1st bit represents the parameter of consonant/vowel
          # 2nd bit represents the parameter of voiced/voiceless
          # 3rd-5th bits represent the seven possible places of articulation
          # 6th-8th bits represent the seven possible manners of articulation
          # 9th,10th,11th bits represent the five possible heights
          # 12th, 13th bits represent the three possible depths
          def encode_phonemes(phonemes=[])
            phonemes.reduce([]) do |code, phone| 
              phone_data = Phonems.lookup(phone)
              bit_1 = phone_data['manner'] == 'vowel' ? 0 : 1
              bit_2 = phone_data['voiceless'] == true ? 0 : 1 
              bit_6_7_8 = encode_articulation(phone_data['manner'])
              
              code << [bit_1, bit_2, 0, 0, 0, *bit_6_7_8, 0, 0, 0, 0]
            end
          end

          def encode_articulation(articulation)
            articulation = 'vowel' if articulation == 'semivowel'
            raise "Invalid articulation: [#{articulation}]" unless ARTICULATIONS.include?(articulation)

            index = ARTICULATIONS.rindex(articulation)
            pad(to_binary(index), 3)
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