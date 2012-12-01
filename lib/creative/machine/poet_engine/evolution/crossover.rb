module Creative
  module Machine
    module PoetEngine
      module Evolution
        class Crossover
          class InvalidCrossover < Exception; end

          CROSSOVER_LIKELIHOOD = 40
        
          class << self
            def crossover(poem_1, poem_2)
              raise InvalidCrossover.new("Both poems empty") if poem_1.nil? && poem_2.nil?
              return poem_1 if poem_2.nil?
              return poem_2 if poem_1.nil?

              poem = [poem_1, poem_2].sample
              poem = crossover_lines(poem_1, poem_2) if crossover?
              poem
            end

            private
          
            def crossover_lines(poem_1, poem_2)
              child_1 = poem_1
              child_2 = poem_2
            
              child_1[0],  child_2[0] =  poem_2[0], poem_1[0]
              child_1[-1], child_2[-1] = poem_2[-1], poem_1[-1]
            
              [child_1, child_2]
            end

            def crossover?
              rand(1..100) <= CROSSOVER_LIKELIHOOD ? true : false
            end
          
          end

        end
      end
    end
  end
end