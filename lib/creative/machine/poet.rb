#Creative poet: Based on www.ncbi.nlm.nih.gov/pubmed/18677746
module Creative
module Machine
  class Poet
    POPULATION_SIZE = 100
    
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
      
      @poems.map{|poem| poem.to_s}[0]
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
      poem_lines = Poem::WORDS_PER_LINE.map{|number_of_words| @lexicon.pick_words(number_of_words) }
      Poem.new(poem_lines)
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
    WORDS_PER_LINE = [5, 7, 5]
    
    def initialize(lines)
      @lines = lines
    end
    
    def to_s
      @lines.map{|line| line.join(" ")}.join("\n")
    end
  end
  
  class Evaluator
    def survivors(population)
      score_poems(population).
      select{|(poem, score)| survivor?(poem, score) }.
      map{|(poem, score)| poem }
    end
    
    private
    def score_poems(population)
      population.map{|generation| [generation, 10] }
    end
    
    def survivor?(poem, score)
      true
    end
  end
    
  class Workspace
  end
  
  class Lexicon
    #[word, word's stress, phonetic structure, syllables]
    
    def pick_words(number_of_words = 10)
      number_of_words.times.map{ |_| clean(words.sample) }.
      reject{|word| word.empty?}
    end
    
    def words
      @words ||= begin
        poem_data = File.read(File.dirname(__FILE__) + "/../../../data/poems.txt")
        poem_data = poem_data.split(" ").flatten
        poem_data
      end
    end
    
    private
    def clean(word)
      word.gsub(/\|\/|"|\.|\!|\?|,|\)|\(/,'').downcase
    end
  end
end
end