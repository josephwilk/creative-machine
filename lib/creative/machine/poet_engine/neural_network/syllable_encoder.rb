require 'creative/machine/poet_engine/phonems'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class SyllableEncoder
          BITS_FOR_SYLLABLES = 66
          SYLLABLE_BITS = PoemEncoder::BITS_FOR_LEXICON_INDEX+1..BITS_FOR_SYLLABLES
          
          def initialize
            @phonem_encoder = PhonemEncoder.new
          end
          
          def encode(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
            
            phonemes_list = Lexicon.phonemes_for(word)
            
            #While we some phonems not grouped by syllables
            if phonemes_list.reduce(false){|listey, phone| listey ||= phone.is_a?(Array)}
              phonems = syllable_phonems(word, syllable_index)
              syllable_encoded_as_binary(syllable, phonems)
            else
              [0] * BITS_FOR_SYLLABLES
            end
          end

          private
          def syllable_encoded_as_binary(syllable, syllable_phonems)
            encoded_phonems = syllable_phonems.map{|phone| @phonem_encoder.encode(phone)}
            encoded_syllable = syllable_encoding(syllable_phonems, encoded_phonems).flatten
            encoded_syllable + stressed?(syllable_phonems)
          end

          def syllable_phonems(word, syllable_index)
            phonemes_list = Lexicon.phonemes_for(word)
            phonemes_list[syllable_index]
          end
          
          def stressed?(syllable_phonems)
            if syllable_phonems.reduce(false){|stressed, phone| stressed ||= PhonemEncoder.stressed_phonem?(phone)}
              [1]
            else
              [0]
            end
          end
          
          def syllable_encoding(phonems_for_syllable, encoded_phonems)
            case structure_of(phonems_for_syllable)
            when [:c, :c, :v, :c, :c]
              encoded_phonems
            when [:c, :c, :v, :c, :c, :c]
              [encoded_phonems[0], encoded_phonems[1], encoded_phonems[2], encoded_phonems[4], encoded_phonems[5]]
            when [:c, :v, :c, :c, :c]
              [empty_binary, encoded_phonems[0], encoded_phonems[1], encoded_phonems[3], encoded_phonems[4]]
            when [:v, :c, :c, :c]
              [empty_binary, empty_binary, encoded_phonems[0], encoded_phonems[2], encoded_phonems[3]]
            when [:c, :c, :c, :v, :c, :c]
              [encoded_phonems[0], encoded_phonems[2], encoded_phonems[3], encoded_phonems[4], encoded_phonems[5]]
            when [:c, :c, :c, :v, :c]
              [encoded_phonems[0], encoded_phonems[2], encoded_phonems[3], encoded_phonems[4], empty_binary]
            when [:c, :c, :c, :v]
              [encoded_phonems[0], encoded_phonems[2], encoded_phonems[3], empty_binary, empty_binary]
            when [:c, :c, :v, :c]
               encoded_phonems + [empty_binary]
            when [:c, :v, :c, :c]
              [empty_binary] + encoded_phonems
            when [:c, :v, :c]
               [empty_binary] + encoded_phonems + [empty_binary]
            when [:c, :c, :v]
               encoded_phonems + [empty_binary, empty_binary]
            when [:v, :c, :c]
              [empty_binary, empty_binary] + encoded_phonems
            when [:c, :v]
              [empty_binary] + encoded_phonems + [empty_binary, empty_binary]
            when [:v, :c]
              [empty_binary, empty_binary] + encoded_phonems + [empty_binary]
            when [:v]
              [empty_binary, empty_binary] + encoded_phonems + [empty_binary, empty_binary]
            when [:c]
              encoded_phonems + [empty_binary, empty_binary, empty_binary, empty_binary]
            else
              [empty_binary] * 5
            end
          end
          
          def empty_binary
            [0] * 13
          end
          
          def structure_of(phonems_for_syllable)
            phonems_for_syllable.map{|phone| vowel?(phone) ? :v : :c }
          end
          
          def vowel?(phone)
            vowels = %W{a e i o u}
            vowels.include?(phone[0].downcase)
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
