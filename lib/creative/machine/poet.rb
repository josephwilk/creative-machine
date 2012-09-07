require 'ruby_fann/neural_network'
require 'creative/machine/poet_engine/neural_network'
require 'creative/machine/poet_engine/rhymer'
require 'json'

#Creative poet: Based on www.ncbi.nlm.nih.gov/pubmed/18677746
module Creative
module Machine
  class Poet
    POPULATION_SIZE = 1000
    
    def initialize
      @lexicon = Lexicon.new
      @evaluator = Evaluator.new
      @poems = nil
    end
    
    def evolve(generations = 10)
      generations.times do 
        @poems ||= randomly_generate_poems
        @poems = @evaluator.survivors(@poems)
        @poems = mutation(@poems)
      end
      
      @poems.map{|poem| poem.to_s}
    end
    
    def mutation(poems)
      #something or nothing to the set of words this limerick carries around (its minilex)
      #something or nothing to the rhyme
      #something or nothing to the lines of the poem.
      poems[0..poems.length/2]
    end
    
    def crossover(poem_1, poem_2)
      #first it may merge the former poem's minilex with the latter's or ignore the latter minilex or do nothing
      #it may take into consideration the other poem's rhyming or ignore the other poem's rhyming altogether or do nothing
      #it will either work with the former and the latter's lines or ignore the latter's lines or do nothing
      [poem_1, poem_2]
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
        inputs = PoetEngine::NeuralNetwork::InputEncoder.convert(poem)
        score = inputs.reduce(0){|score, input| score += @neural_network.run(input)[0]}

        [poem, score]
      end
    end
    
    def survivor?(poem, score)
      true
    end
  end
    
  class Workspace
  end
  
  class Lexicon
    def self.lookup(word)
      @data ||= JSON.parse(File.read(File.dirname(__FILE__) + '/../../../data/lookup_dictionary.json'))
      @data[word]
    end

    def self.no_syllables_in(word)
      word_data = Lexicon.lookup(word)
      if word_data
        word_data['syllables'].split("-").count
      end
    end
    
    def pick_words(total_syllables = 10)
      poem_words = []
      while total_syllables > 0
        word = clean(words.sample)
        next unless word

        syllable_count = Lexicon.no_syllables_in(word)
        next unless syllable_count

        if (total_syllables - Lexicon.no_syllables_in(word)) >= 0
          poem_words << word
          total_syllables = total_syllables - Lexicon.no_syllables_in(word)
        end
      end
      poem_words
    end
    
    def words
      @words ||= begin
        poem_data = File.read(Haiku::SOURCE_WORDS_FILE)
        poem_data = poem_data.split(" ").flatten
        poem_data
      end
    end
    
    private
    def clean(word)
      return word unless word
      word.gsub(/\|\/|"|\.|\!|\?|,|\)|\(/,'').downcase
    end
  end
end
end