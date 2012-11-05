module Creative
  module Machine
    module PoetEngine
      module Evolution
        class Mutator

          def initialize(lexicon)
            @lexicon = lexicon
          end
        
          def mutate(poem)
            poem = word_mutation(poem) if mutate?
            poem = line_mutation(poem) if mutate?

            poem
          end

          def word_mutation(poem)
            line_index = rand(poem.length)
            line = poem[line_index]

            word_index = rand(line.length)
            word = line[word_index]

            new_word = @lexicon.pick_word(Lexicon.no_syllables_in(word))
            line[word_index] = new_word

            poem
          end
          
          def line_mutation(poem)
            line_index = rand(poem.length)

            syllable_total = Haiku::SYLLABLES_PER_LINE[line_index]

            new_line = @lexicon.pick_words(syllable_total)

            poem[line_index] = new_line
            poem
          end
          
          private
          def mutate?
            rand(2) == 1 ? true : false
          end

        end
      end
    end
  end
end