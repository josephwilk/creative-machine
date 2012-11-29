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
          end

          private

          def word_mutation(poem)
            line_index = Kernel.rand(poem.length)
            line = poem[line_index]

            word_index = Kernel.rand(line.length)
            word = line[word_index]

            loop do
              new_word = @lexicon.pick_word(Lexicon.no_syllables_in(word))
              break if valid_mutation_word?(new_word, word_index, line)
            end

            line[word_index] = new_word

            poem
          end

          def valid_mutation_word?(new_word, word_index, line)
            if word_index == 0
              !GrammerChecker.invalid_particles?(new_word, line[word_index + 1])
            elsif word_index == line.length - 1
              !GrammerChecker.invalid_particles?(line[word_index - 1], new_word)
            else
              !GrammerChecker.invalid_particles?(new_word, line[word_index + 1]) &&
              !GrammerChecker.invalid_particles?(line[word_index - 1], new_word)
            end
          end
          
          def line_mutation(poem)
            line_index = rand(poem.length)

            syllable_total = Haiku::SYLLABLES_PER_LINE[line_index]

            new_line = @lexicon.pick_words(syllable_total)

            poem[line_index] = new_line
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