require 'nokogiri'
require 'open-uri'

module Creative
  module Machine
    class Rhymer
      URL = "http://www.rhymezone.com/r/rhyme.cgi?typeofrhyme=perfect&org1=syl&org2=l&org3=y"
      CACHE_DIR = File.dirname(__FILE__) + "/../../../data/rhythms"

      class << self
        def rhyming_with(word)
          return fetch_from_cache(word) if cached?(word)
            
          rhyming_words = find_rhyming_words_for(word)
          
          cache(word, rhyming_words)

          rhyming_words || []
        end
        
        private
        def find_rhyming_words_for(word)
          doc = Nokogiri::HTML(open("#{URL}&Word=#{URI.escape(word)}"))
          doc.xpath('//a[starts-with(@href, "d=")]').map{|a| a.text}
        end

        def cache(word, rhyming_words)
          File.open("#{CACHE_DIR}/#{word}", "w") do |f|
            f.write(rhyming_words.join(','))
          end
          @rythm_cache ||= {}
          @rythm_cache[word] = rhyming_words
        end
        
        def cached?(word)
          (@rythm_cache||{}).has_key?(word) || File.exists?("#{CACHE_DIR}/#{word}")
        end
        
        def fetch_from_cache(word)
          if (@rythm_cache||{}).has_key?(word)
            @rythm_cache[word]
          else
            data = File.read(File.dirname(__FILE__) + "/../../../data/rhythms/#{word}")
            return data.split(",")
          end
        end
      end

    end
  end
end