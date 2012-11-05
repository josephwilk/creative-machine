require 'creative/machine/poet_engine/phonemes'

module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork

        class SyllableEncoder
          BITS_FOR_SYLLABLES = 66
          SYLLABLE_BITS = PoemEncoder::BITS_FOR_LEXICON_INDEX+1..BITS_FOR_SYLLABLES
          
          def initialize
            @phoneme_encoder = PhonemeEncoder.new
          end
          
          def encode(word, syllable, syllable_index)
            syllable_count = Lexicon.syllables_in(word).count
            
            phonemes_list = Lexicon.phonemes_for(word)
            
            #While we have some phonemes not grouped by syllables
            if phonemes_list.reduce(false){|listey, phone| listey ||= phone.is_a?(Array)}
              phonemes = syllable_phonemes(word, syllable_index)
              syllable_encoded_as_binary(syllable, phonemes)
            else
              #Skipping word
              [0] * BITS_FOR_SYLLABLES
            end
          end

          private
          def syllable_encoded_as_binary(syllable, syllable_phonemes)
            encoded_phonemes = syllable_phonemes.map{|phone| @phoneme_encoder.encode(phone)}
            encoded_syllable = syllable_encoding(syllable_phonemes, encoded_phonemes).flatten
            encoded_syllable + stressed?(syllable_phonemes)
          end

          def syllable_phonemes(word, syllable_index)
            phonemees_list = Lexicon.phonemes_for(word)
            phonemees_list[syllable_index]
          end
          
          def stressed?(syllable_phonemes)
            if syllable_phonemes.reduce(false){|stressed, phone| stressed ||= PhonemeEncoder.stressed_phoneme?(phone)}
              [1]
            else
              [0]
            end
          end
          
          def syllable_encoding(phonemes_for_syllable, encoded_phonemes)
            case structure_of(phonemes_for_syllable)
            when [:c, :c, :v, :c, :c]
              encoded_phonemes
            when [:c, :c, :v, :c, :c, :c]
              [encoded_phonemes[0], encoded_phonemes[1], encoded_phonemes[2], encoded_phonemes[4], encoded_phonemes[5]]
            when [:c, :v, :c, :c, :c]
              [empty_binary, encoded_phonemes[0], encoded_phonemes[1], encoded_phonemes[3], encoded_phonemes[4]]
            when [:v, :c, :c, :c]
              [empty_binary, empty_binary, encoded_phonemes[0], encoded_phonemes[2], encoded_phonemes[3]]
            when [:c, :c, :c, :v, :c, :c]
              [encoded_phonemes[0], encoded_phonemes[2], encoded_phonemes[3], encoded_phonemes[4], encoded_phonemes[5]]
            when [:c, :c, :c, :v, :c]
              [encoded_phonemes[0], encoded_phonemes[2], encoded_phonemes[3], encoded_phonemes[4], empty_binary]
            when [:c, :c, :c, :v]
              [encoded_phonemes[0], encoded_phonemes[2], encoded_phonemes[3], empty_binary, empty_binary]
            when [:c, :c, :v, :c]
               encoded_phonemes + [empty_binary]
            when [:c, :v, :c, :c]
              [empty_binary] + encoded_phonemes
            when [:c, :v, :c]
               [empty_binary] + encoded_phonemes + [empty_binary]
            when [:c, :c, :v]
               encoded_phonemes + [empty_binary, empty_binary]
            when [:v, :c, :c]
              [empty_binary, empty_binary] + encoded_phonemes
            when [:c, :v]
              [empty_binary] + encoded_phonemes + [empty_binary, empty_binary]
            when [:v, :c]
              [empty_binary, empty_binary] + encoded_phonemes + [empty_binary]
            when [:v]
              [empty_binary, empty_binary] + encoded_phonemes + [empty_binary, empty_binary]
            when [:c]
              encoded_phonemes + [empty_binary, empty_binary, empty_binary, empty_binary]
            else
              [empty_binary] * 5
            end
          end
          
          def empty_binary
            [0] * PhonemeEncoder::BITS_FOR_PHONEME
          end
          
          def structure_of(phonemes_for_syllable)
            phonemes_for_syllable.map{|phoneme| vowel?(phoneme) ? :v : :c }
          end
          
          def vowel?(phoneme)
            vowels = %W{a e i o u}
            vowels.include?(phoneme[0].downcase)
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
