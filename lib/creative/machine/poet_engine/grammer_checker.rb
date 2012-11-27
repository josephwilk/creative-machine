module Creative
  module Machine
    module PoetEngine

      class GrammerChecker
        INVALID_PARTICLE_COMBINATIONS = [%W{the of},
                                         %W{of in},
                                         %W{the in},
                                         %W{the with},
                                         %W{to to},
                                         %W{a a},
                                         %W{the the}
                                         %W{in in}
                                         %W{of of}
                                         %W{i i}]

        def self.invalid_particles?(current_word, new_word)
          INVALID_PARTICLE_COMBINATIONS.include?([current_word, new_word])
        end
      end

    end
  end
end