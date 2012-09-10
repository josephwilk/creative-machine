require 'nokogiri'
require 'open-uri'
require 'json'

module LexiconBuilder
  class << self
    URL = 'http://dictionary.reference.com/browse'
    
    def haiku_words
      words = File.read(File.dirname(__FILE__) + '/../data/haiku.txt')
      words = words.split(' ').
                    reject {|word| word =~ /-|--/}.
                    map{|word| word.downcase}.
                    map{|word| word.gsub(/[^\w\d]/, '')}

      words
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

      phonemes = how_do_i_pronounce(word)
      
      {:word => word,
       :syllables => word_with_syllables_seperated,
       :pronouncations => pronouncations,
       :phonemes => phonemes}
    rescue
      puts "#{word} lookup failed: #{$!}"
      nil
    end
    
    private

    def how_do_i_pronounce(word)
      @pronouncation_dictionary ||= build_pronuciation_dictionary
      @pronouncation_dictionary[word]
    end
  
    def build_pronuciation_dictionary
      dictionary = {}
    
      File.open(File.dirname(__FILE__) + '/../data/cmudict/cmudict.0.7a') do |f|
        f.readlines.each do |line|
          word, *pron = line.strip.split(' ')
          next unless word && !word.empty? && !word[/[^A-Z]+/]
          dictionary[word.downcase] = pron
        end
      end
      
      dictionary
    end
  end
  
end

namespace :lexicon do
  desc "Download latest cmu-dictionary"
  task :download_cmu do
    if !File.directory?(File.dirname(__FILE__) + '/../data/cmudict')
      puts "[INFO] Downloading cmudict dictionaries"
    `wget http://cmusphinx.svn.sourceforge.net/viewvc/cmusphinx/trunk/cmudict/?view=tar -O data/cmudict.tar.gz && tar -xf data/cmudict.tar.gz`
    end
  end
  
  desc "map words to syllables/pronuciation/emphasis"
  task :build => [:download_cmu, :format_lookup] do
    error_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup_fails.json', 'w')
    moderation_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup_moderation.json', 'w')
    word_log = File.open(File.dirname(__FILE__) + '/../tmp/lookup.json', 'w')

    seen = {}

    LexiconBuilder.haiku_words.each do |word|
      data = LexiconBuilder.lookup(word)
      next unless data
      next if seen[word]
      
      if (data[:syllables].gsub('-','')).length != word.length
        if word[-1] == 's' && word[0..-2] == data[:syllables].gsub('-','')
          data[:syllables] = data[:syllables] + "s"
          data[:pronouncations] = data[:pronouncations].map{|word| word + "s" }
          
          file_to_log = !data[:phonemes] ? error_log : word_log
          file_to_log.write(data.to_json + "\n")
          file_to_log.flush          
        else
          moderation_log.write(data.to_json + "\n")
        end
      else
        file_to_log = !data[:phonemes] ? error_log : word_log
        file_to_log.write(data.to_json + "\n")
        file_to_log.flush          
      end
      seen[word] = true
    end
    
    [word_log, error_log, moderation_log].map(&:close)

    puts File.expand_path(File.dirname(__FILE__) + '/../') + '/tmp/lookup.json'
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