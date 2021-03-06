require 'creative/machine/poet_engine/grammer_checker'

module Creative
  module Machine
    module PoetEngine
      module Evolution
        class Mutator
          MUTATION_LIKELIHOOD = 60

          def initialize(lexicon)
            @lexicon = lexicon
          end
        
          def mutate(poem)
            poem = word_mutation(poem) if mutate?
            poem = line_mutation(poem) if mutate?
            poem
          end

          private

          def word_mutation(poem)
            word, word_index, line_index = *poem.pick_random_word

            new_word = loop do
              new_word = @lexicon.pick_word_with_same_number_of_syllables_as(word)
              break(new_word) if valid_mutation_word?(new_word, word_index, poem.line(line_index))
            end

            poem.replace_word(word_index, line_index, new_word)

            poem
          end

          def valid_mutation_word?(new_word, word_index, line)
            GrammerChecker.valid_sentence?(new_word, word_index, line)
          end
          
          def line_mutation(poem)
            _, line_index = *poem.pick_random_line

            syllable_total = poem.syllables_for_line(line_index)

            new_line = @lexicon.pick_words(syllable_total)

            poem.replace_line(line_index, new_line)
            
            poem
          end
          
          def mutate?
            Kernel.rand(1..100) <= MUTATION_LIKELIHOOD ? true : false
          end

        end
      end
    end
  end
end