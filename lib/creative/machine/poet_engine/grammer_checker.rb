module Creative
  module Machine
    module PoetEngine

      module GrammerChecker
        INVALID_PARTICLE_COMBINATIONS = [%W{the of},
                                         %W{of in},
                                         %W{the in},
                                         %W{the with},
                                         %W{to to},
                                         %W{a a},
                                         %W{the the},
                                         %W{in in},
                                         %W{of of},
                                         %W{i i}]


        def self.valid_sentence?(new_word, new_word_index, line)
          if new_word_index == 0
            GrammerChecker.valid_particles?(new_word, line[new_word_index + 1])
          elsif new_word_index == line.length - 1
            GrammerChecker.valid_particles?(line[new_word_index - 1], new_word)
          else
            GrammerChecker.valid_particles?(new_word, line[new_word_index + 1]) &&
          GrammerChecker.valid_particles?(line[new_word_index - 1], new_word)
          end
        end

        def self.valid_particles?(current_word, new_word)
          !INVALID_PARTICLE_COMBINATIONS.include?([current_word, new_word])
        end

      end

    end
  end
end