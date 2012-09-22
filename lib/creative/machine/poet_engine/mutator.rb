
module Creative
  module Machine
    module PoetEngine
      class Mutator
        
        class << self
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
            rand(1) == 1 ? true : false 
          end
          
        end

      end
    end
  end
end