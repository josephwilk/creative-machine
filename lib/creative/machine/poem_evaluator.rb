module Creative
module Machine

  class PoemEvaluator
    SURVIVOR_SCORE_LIMIT = 88

    def initialize(lexicon)
      @poem_encoder = PoetEngine::NeuralNetwork::PoemEncoder.new(lexicon)
      @neural_network = PoetEngine::NeuralNetwork
    end
    
    def survivors(population)
      score_poems(population).
      select{|(poem, score)| survivor?(poem, score)}.
      sort{|(poem_1, score_1), (poem_2, score_2)| score_1 <=> score_2}.
      map{|(poem, score)| puts poem, score, "\n"; poem}
    end
    
    private
    def score_poems(population)
      population.map do |poem|
        inputs = @poem_encoder.encode(poem)
        score = inputs.reduce(0){|score, input| score += @neural_network.score(input)}

        [poem, score]
      end
    end
    
    def survivor?(poem, score)
      true
    end
  end

end
end