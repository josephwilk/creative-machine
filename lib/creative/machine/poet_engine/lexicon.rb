module Creative
  module Machine
    module PoetEngine

  	  class Lexicon
        class NoPhonemesFound < Exception; end;
        
        DICTIONARY_FILE = File.dirname(__FILE__) + '/../../../../data/lookup_dictionary.json'
    
  	    def self.lookup(word)
  	      @data ||= JSON.parse(File.read(DICTIONARY_FILE))
  	      @data[word]
  	    end

        def self.phonemes_for(word)
  	      word_data = Lexicon.lookup(word)
          raise NoPhonemesFound.new("No phonemes for word: #{word}") if word_data['phonemes'] == [nil]

  	      word_data ? word_data['phonemes'] : []
        end
        
        def self.syllables_in(word)
  	      word_data = Lexicon.lookup(word)
  	      if word_data
  	        word_data['syllables']
  	      end
        end

  	    def self.no_syllables_in(word)
  	      word_data = Lexicon.lookup(word)
  	      if word_data
  	        word_data['syllables'].count
  	      end
  	    end
        
        def index(word)
  	      @data ||= JSON.parse(File.read(DICTIONARY_FILE))
          @data.keys.sort.index(word)
        end
    
  	    def pick_words(total_syllables = 10)
  	      poem_words = []
  	      while total_syllables > 0
  	        word = clean(words.sample)
  	        next unless word

  	        syllable_count = Lexicon.no_syllables_in(word)
  	        next unless syllable_count

  	        if ((total_syllables - Lexicon.no_syllables_in(word)) >= 0) && !GrammerChecker.invalid_particles?(poem_words[-1], word)
  	          poem_words << word
  	          total_syllables = total_syllables - Lexicon.no_syllables_in(word)
  	        end
  	      end
  	      poem_words
  	    end

        def pick_word(syllable_count)
          word = nil
          while(!word)
            candiate_word = clean(words.sample)
	          next unless candiate_word
            word = candiate_word if Lexicon.no_syllables_in(candiate_word) == syllable_count
          end
          word
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
end