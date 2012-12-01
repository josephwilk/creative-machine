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
          
            def crossover_lines(parent_poem_1, parent_poem_2)
              child_1 = parent_poem_1
              child_2 = parent_poem_2
            
              child_1.replace_line(0, parent_poem_2.line(0))
              child_2.replace_line(0, parent_poem_1.line(0))

              child_1.replace_line(-1, parent_poem_2.line(-1))
              child_1.replace_line(-1, parent_poem_1.line(-1))
            
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