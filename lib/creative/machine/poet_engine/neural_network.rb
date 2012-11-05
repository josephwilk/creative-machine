Dir[File.dirname(__FILE__) + '/neural_network/*.rb'].each { |file| require file }

require 'tlearn'

module Creative
  module Machine
    module PoetEngine

      module NeuralNetwork
        class << self
          def score(input)
            tlearn = TLearn::Run.new(config)
            ratings = tlearn.fitness(input, iterations = 10, path = "data/weights")
            if ratings
              rank = ratings.rindex(ratings.max) + 1
            else
              0
            end
          end

          def config
            {:number_of_nodes => 86,
             :selected => 1..86,
             :output_nodes    => 41..46,
             :linear          => 47..86,
             :weight_limit    => 1.00,
             :connections     => [{1..81   => 0},
                                  {1..40   => :i1..:i77},
                                  {41..46  => 1..40},
                                  {1..40   => 47..86},
                                  {47..86  => [1..40, {:max => 1.0, :min => 1.0}, :fixed, :one_to_one]}]}
          end
        end
      end

    end
  end
end