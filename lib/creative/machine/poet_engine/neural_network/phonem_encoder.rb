require 'creative/machine/poet_engine/phonems'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class InvalidPhone < Exception; end;

        class PhonemEncoder
          ARTICULATIONS = %W{fricative vowel stop liquid nasal affricate aspirate}
          BITS_FOR_PHONEM = 13

          def encode(phone)
            phone_data = Phonems.lookup(phone)
            
            raise InvalidPhone.new("Invalid phone: [#{phone}]") unless phone_data
            
            binary_code_for(phone_data)
          end
          
          private

          # 1st bit represents the parameter of consonant/vowel
          # 2nd bit represents the parameter of voiced/voiceless
          # 3rd-5th bits represent the seven possible places of articulation
          # 6th-8th bits represent the seven possible manners of articulation
          # 9th,10th,11th bits represent the five possible heights
          # 12th, 13th bits represent the three possible depths
          def binary_code_for(phone_data)
            bit_1 = phone_data['manner'] == 'vowel' ? 0 : 1
            bit_2 = phone_data['voiceless'] == true ? 0 : 1 
            bit_3_4_5 = [0, 0, 0] 
            bit_6_7_8 = encode_articulation(phone_data['manner'])
            bit_9_10_11 = [0, 0, 0]
            bit_12_13 = [0, 0]
              
            [bit_1, bit_2, *bit_3_4_5, *bit_6_7_8, *bit_9_10_11, *bit_12_13]
          end

          def encode_articulation(articulation)
            articulation = 'vowel' if articulation == 'semivowel'
            raise "Invalid articulation: [#{articulation}]" unless ARTICULATIONS.include?(articulation)

            index = ARTICULATIONS.rindex(articulation)
            pad(to_binary(index), 3)
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