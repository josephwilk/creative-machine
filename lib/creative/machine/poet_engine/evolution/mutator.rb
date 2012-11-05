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
            poem
          end
          
          def line_mutation(poem)
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