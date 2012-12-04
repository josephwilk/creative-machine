require 'creative/machine/poet_engine/phonemes'
require 'creative/machine/poet_engine/neural_network/binary_helper'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class PhonemeEncoder
          include BinaryHelper

          ARTICULATIONS         = %W{fricative vowel stop liquid nasal affricate aspirate}
          PLACE_OF_ARTICULATION = %W{bilabial alveolar velar labiodental palatal interdental glottal}
          HEIGHT                = %W{high low-high mid low-mid low diphthong}
          DEPTH                 = %W{back front central}
          
          BITS_FOR_PHONEME = 13

          def self.stressed_phoneme?(phone)
            phone_data = Phonemes.lookup(phone)
            phone_data['stress'] == 'primary'
          end

          def encode(phone)
            phone_data = Phonemes.lookup(phone)
            binary_code_for(phone_data)
          end
          
          private
          
          def binary_code_for(phone_data)
            bit_1 = phone_data['manner'] == 'vowel' ? 0 : 1
            bit_2 = phone_data['voiceless'] == true ? 0 : 1 
            bit_3_4_5 = encode_place_of_articulation(phone_data['point'])
            bit_6_7_8 = encode_manner_of_articulation(phone_data['manner'])
            bit_9_10_11 = encode_height(phone_data['height'])
            bit_12_13 = encode_depth(phone_data['depth'])
              
            [bit_1, bit_2, *bit_3_4_5, *bit_6_7_8, *bit_9_10_11, *bit_12_13]
          end

          def encode_height(height)
            return [0, 0, 0] unless HEIGHT.include?(height)
            
            index = HEIGHT.rindex(height) + 1
            pad(to_binary(index), 3)
          end
          
          def encode_depth(depth)
            return [0, 0] unless DEPTH.include?(depth)
            
            index = HEIGHT.rindex(depth) + 1
            pad(to_binary(index), 2)
          end
          
          def encode_place_of_articulation(point)
            return [0, 0, 0] unless PLACE_OF_ARTICULATION.include?(point)

            index = PLACE_OF_ARTICULATION.rindex(point) + 1
            pad(to_binary(index), 3)
          end

          def encode_manner_of_articulation(articulation)
            articulation = 'vowel' if articulation == 'semivowel'
            return [0, 0, 0] unless ARTICULATIONS.include?(articulation)

            index = ARTICULATIONS.rindex(articulation) + 1
            pad(to_binary(index), 3)
          end

        end
        
      end
    end
  end
end