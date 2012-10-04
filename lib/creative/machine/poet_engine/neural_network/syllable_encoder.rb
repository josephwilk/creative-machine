require 'creative/machine/poet_engine/phonems'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class SyllableEncoder
          ARTICULATIONS = %W{fricative vowel stop liquid nasal affricate aspirate}

          BITS_FOR_SYLLABLES = 66
          SYLLABLE_BITS = PoemEncoder::BITS_FOR_LEXICON_INDEX+1..BITS_FOR_SYLLABLES
          
          def encode(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
             
            phonemes = Lexicon.phonemes_for(word)
            if syllable_count == 1
              code = encode_phonemes(phonemes[0]).flatten
              pad(code, BITS_FOR_SYLLABLES)
            else
              [0] * BITS_FOR_SYLLABLES
            end
          end
          
          private
          
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
              bit_3_4_5 = [0, 0, 0] 
              bit_6_7_8 = encode_articulation(phone_data['manner'])
              bit_9_10_11 = [0, 0, 0]
              bit_12_13 = [0, 0]
              
              code << [bit_1, bit_2, *bit_3_4_5, *bit_6_7_8, *bit_9_10_11, *bit_12_13]
            end
          end

          def encode_articulation(articulation)
            articulation = 'vowel' if articulation == 'semivowel'
            raise "Invalid articulation: [#{articulation}]" unless ARTICULATIONS.include?(articulation)

            index = ARTICULATIONS.rindex(articulation)
            pad(to_binary(index), 3)
          end
          
          def to_binary(number)
            number.to_i.to_s(2).split('').map(&:to_i)
          end
          
          def pad(input, size)
            pad_length = size - input.length
            pad_length > 0 ? ([0] * pad_length) + input : input
          end
          
        end
        
      end
    end
  end
end
