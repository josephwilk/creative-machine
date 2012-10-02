require 'nokogiri'
require 'open-uri'
require 'json'

require 'pronounce'

module LexiconBuilder
  class << self
    URL = 'http://dictionary.reference.com/browse'
    
    def haiku_words
      return @words if @words
      words = File.read(File.dirname(__FILE__) + '/../data/haiku.txt')
      words = words.split(' ').
                    reject {|word| word =~ /-|--/}.
                    map{|word| word.downcase}.
                    map{|word| word.gsub(/[^\w\d]/, '')}

      @words ||= words
    end
  
    def lookup(word)
      doc = Nokogiri::HTML(open("#{URL}/#{URI.escape(word)}"))

      nodes = doc.xpath('//h2[@class="me"]')
      return unless nodes && nodes.first
      word_with_syllables_seperated = nodes.first.text
      word_with_syllables_seperated = word_with_syllables_seperated.gsub(/\u00B7/, '-')
    
      pronouncations = doc.xpath('//span[@class="show_spellpr"]/span[@class="pron"]').
                           map{|a| a.text}.
                           reject{|w| w =~ /,|;/}.
                           uniq

      phonemes = Pronounce.how_do_i_pronounce(word)
      
      word_with_syllables_seperated, pronouncations = *correct_any_bad_lookups(word, word_with_syllables_seperated, pronouncations)       

      pronouncations = correct_any_bad_pronounications(pronouncations, word_with_syllables_seperated)

      if word_with_syllables_seperated.count == 1 && phonemes
        phonemes = [phonemes]
      end
      
      {:word => word,
       :syllables => word_with_syllables_seperated,
       :pronouncations => pronouncations,
       :phonemes => phonemes}
    rescue
      puts "#{word} lookup failed: #{$!} #{$!.backtrace.join("\n")}"
      nil
    end
    
    def correct_any_bad_pronounications(pronouncations, syllables)
      syllables_count = syllables.count
      pronouncations.select{|pronouncation| pronouncation.split('-').reject(&:empty?).count == syllables_count}.
                     map{|pronouncation| pronouncation.split('-') }
    end
    
    def correct_any_bad_lookups(word, syllables, pronouncations)
      dictionary_looked_up_word = syllables.gsub('-','')
      
      if failed_match?(dictionary_looked_up_word, word)
        if word[-1] == 's' && word[0..-2] == dictionary_looked_up_word
          syllables = syllables + "s"
          pronouncations = pronouncations.map{|word| word + "s" }  
        elsif word[-3..-1] == 'ing' && word[0..-4] == dictionary_looked_up_word
          syllables = syllables + "-ing"
          pronouncations = pronouncations.map{|word| word + "-ing" }
        end
      end
      
      [syllables.split("-"), pronouncations]
    end
    
    private

    def failed_match?(syllables, word)
      (syllables.gsub('-','')).length != word.length
    end
  end
  
end

namespace :lexicon do  
  desc "map words to syllables/pronuciation/emphasis"
  task :build => [:format_lookup] do
    error_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup_fails.json', 'w')
    moderation_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup_moderation.json', 'w')
    word_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup.json', 'w')

    seen = {}

    LexiconBuilder.haiku_words.each do |word|
      data = LexiconBuilder.lookup(word)
      next unless data
      next if seen[word]
      
      log = if !data[:phonemes]
        error_log        
      elsif (data[:syllables].join('')).length != word.length
        moderation_log
      else
        word_log
      end
        
      log.write(data.to_json + "\n")
      log.flush          

      seen[word] = true
    end
    
    [word_log, error_log, moderation_log].map(&:close)

    puts File.expand_path(File.dirname(__FILE__) + '/../') + '/tmp/lookup.json'
  end
  
  desc "process moderation"
  task :moderation_process do
    word_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup.json', 'a')
    File.open(File.dirname(__FILE__) + '/../tmp/lookup_moderation.json') do |f|
      f.readlines.each do |line|
        data = JSON.parse(line)
        
        next unless data['phonemes']

        word = data['word']
        dictionary_looked_up_word = data['syllables'].gsub('-','')
      
        if word[-1] == 's' && word[0..-2] == dictionary_looked_up_word
          data['syllables'] = data['syllables'] + "s"
          data['pronouncations'] = data['pronouncations'].map{|word| word + "s" }  
          
          word_log.write(data.to_json + "\n") 
        elsif word[-3..-1] == 'ing' && word[0..-4] == dictionary_looked_up_word
          data['syllables'] = data['syllables'] + "-ing"
          data['pronouncations'] = data['pronouncations'].map{|word| word + "-ing" }
          
          word_log.write(data.to_json + "\n") 
        end

      end
    end
    word_log.close
  end
  
  desc "format json line segments into a single json hash"
  task :format_lookup do
    data = File.read(File.dirname(__FILE__) + '/../tmp/lookup.json')
    lines = data.split("\n")
    result = lines.reduce({}) do |result, line|
      word_data = JSON.parse(line)
      word = word_data.delete('word')
      result[word] = word_data
      result
    end
    File.open(File.dirname(__FILE__) + '/../data/lookup_dictionary.json', 'w') do |f|
      f.write(result.to_json)
    end
  end
  
end