module Creative
  module Machine
    module PoetEngine
      module Evolution
        class Crossover
        
          class << self
            def crossover(poem_1, poem_2)
              poem = [poem_1, poem_2][rand(1)]
              poem = crossover_lines(poem_1, poem_2) if crossover?
              poem
            end
          
            def crossover_lines(poem_1, poem_2)
              child_1 = poem_1
              child_2 = poem_2
            
              child_1[0],  child_2[0] =  poem_2[0], poem_1[0]
              child_1[-1], child_2[-1] = poem_2[-1], poem_1[-1]
            
              [child_1, child_2]
            end

            private
            def crossover?
              rand(1) == 1 ? true : false 
            end
          
          end

        end
      end
    end
  end
end