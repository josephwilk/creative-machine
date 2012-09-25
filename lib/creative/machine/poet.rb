require 'ruby_fann/neural_network'
require 'creative/machine/poet_engine/neural_network'
require 'creative/machine/poet_engine/rhymer'
require 'creative/machine/poet_engine/evolution/mutator'
require 'creative/machine/poet_engine/evolution/crossover'
require 'creative/machine/poet_engine/lexicon'
require 'json'

#Creative poet: Based on www.ncbi.nlm.nih.gov/pubmed/18677746
module Creative
module Machine
  class Poet
    POPULATION_SIZE = 1000
    
    def initialize
      @lexicon = PoetEngine::Lexicon.new
      @evaluator = Evaluator.new
      @mutator = PoetEngine::Evolution::Mutator.new(@lexicon)
      @poems = nil
    end
    
    def evolve(generations = 100)
      generations.times do 
        @poems ||= randomly_generate_poems
        @poems = @evaluator.survivors(@poems)
        @poems = mutation(@poems)
        @poems = crossover(@poems)
      end
      
      @poems.map{|poem| poem.to_s}
    end
    
    def mutation(poems)
      poems.map {|poem| @mutator.mutate(poem) }
    end
    
    def crossover(poems)
      new_poems = []
      poems.each_slice(2) {|poem_1, poem_2| new_poems << PoetEngine::Evolution::Crossover.crossover(poem_1, poem_2)}
      new_poems.flatten
    end
    
    private
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
  
  class Poem
    def initialize(lines)
      @lines = lines
    end
    
    def syllables
      #TODO: extract syllables
      @lines.join().split
    end
    
    def to_s
      @lines.map{|line| line.join(" ")}.join("\n")
    end
  end
  
  class Haiku < Poem
    SOURCE_WORDS_FILE = File.dirname(__FILE__) + "/../../../data/haiku.txt"
    
    LINES = 3
    SYLLABLES_PER_LINE = [5, 7, 5]
  end
  
  class Limerick < Poem
    SOURCE_WORDS_FILE = File.dirname(__FILE__) + "/../../../data/poems.txt"
    
    LINES = 5
    #Five lines. 
    #Third and fourth lines rhyme and share a fixed rhythm
    #First, second and fifth share a rhyme and different fixed rhythm.
    #5th line punch line,
  end
  
  class Evaluator
    def initialize
      @neural_network = RubyFann::Standard.new(:num_inputs => 77, 
                                               :hidden_neurons => [2, 8, 4, 3, 4], 
                                               :num_outputs => 1)
    end
    
    def survivors(population)
      score_poems(population).
      select{|(poem, score)| survivor?(poem, score) }.
      map{|(poem, score)| poem }
    end
    
    private
    def score_poems(population)
      population.map do |poem|
        inputs = PoetEngine::NeuralNetwork::PoemEncoder.encode(poem)
        score = inputs.reduce(0){|score, input| score += @neural_network.run(input)[0]}

        [poem, score]
      end
    end
    
    def survivor?(poem, score)
      true
    end
  end
    
end
end