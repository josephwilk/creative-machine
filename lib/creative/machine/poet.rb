require 'json'

require 'creative/machine/poet_engine/neural_network'
require 'creative/machine/poet_engine/rhymer'
require 'creative/machine/poet_engine/evolution/mutator'
require 'creative/machine/poet_engine/evolution/crossover'
require 'creative/machine/poet_engine/lexicon'
require 'creative/machine/poet_engine/grammer_checker'

require 'creative/machine/poem_evaluator'
require 'creative/machine/haiku'


#Based on ideas from www.ncbi.nlm.nih.gov/pubmed/18677746
module Creative
module Machine
  class Poet
    POPULATION_SIZE = 10000
    
    def initialize
      @lexicon = PoetEngine::Lexicon.new
      @evaluator = PoemEvaluator.new(@lexicon)
      @mutator = PoetEngine::Evolution::Mutator.new(@lexicon)
      @crossover = PoetEngine::Evolution::Crossover
      @poems = nil
    end
    
    def evolve(generations = 100)
      generations.times do |generation|
        @poems ||= randomly_generate_poems

        puts "Generation #{generation}: #{@poems.count} poems"

        @poems = @evaluator.survivors(@poems)
        @poems = mutation(@poems)
        @poems = crossover(@poems)
      end
      
      @poems.map{|poem| poem.to_s}
    end

    private
    def mutation(poems)
      poems.map {|poem| @mutator.mutate(poem) }
    end
    
    def crossover(poems)
      new_poems = []
      poems.each_slice(2) {|poem_1, poem_2| new_poems << @crossover.crossover(poem_1, poem_2)}
      new_poems.flatten
    end

    def randomly_generate_poems
      POPULATION_SIZE.times.map{|_| randomly_generate_poem }
    end
    
    def randomly_generate_poem
      poem_lines = Haiku::LINES.times.map{|index| @lexicon.pick_words(Haiku::SYLLABLES_PER_LINE[index]) }

      Haiku.new(poem_lines)
    end
  
    def find_rythming_words(words)
      words.map do |word| 
        Rhymer.rhyming_with(word) 
      end
    end
    
    def find_correct_stress_pattern(words)
      words
    end
  end
    
end
end