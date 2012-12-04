module Creative
  module Machine
    module PoetEngine
      module NeuralNetwork
        
        module BinaryHelper

          def pad(input, size)
            pad_length = size - input.length
            pad_length > 0 ? ([0] * pad_length) + input : input
          end

          def to_binary(number)
            number.to_i.to_s(2).split('').map(&:to_i)
          end

        end

      end
    end
  end
end