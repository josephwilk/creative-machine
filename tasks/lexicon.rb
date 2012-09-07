require 'nokogiri'
require 'open-uri'
require 'json'

module Lexicon
  class << self
    def haiku_words
      words = File.read(File.dirname(__FILE__) + '/../data/haiku.txt')
      words = words.split(' ').
                    reject {|word| word =~ /-|--/}.
                    map{|word| word.downcase}.
                    map{|word| word.gsub(/[^\w\d]/, '')}

      words
    end
  
  
    def how_do_i_pronounce(word)
      @pronouncation_dictionary ||= build_pronuciation_dictionary
      @pronouncation_dictionary[word]
    end

    private
  
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
  task :build => [:download_cmu] do
    URL = 'http://dictionary.reference.com/browse'

    File.open(File.dirname(__FILE__) + '/../tmp/lookup_fails.json', 'w') do |error_log|
      File.open(File.dirname(__FILE__) + '/../tmp/lookup.json', 'w') do |word_log|
        word_data = Lexicon.haiku_words.map do |word|
        begin
          doc = Nokogiri::HTML(open("#{URL}/#{URI.escape(word)}"))

          nodes = doc.xpath('//h2[@class="me"]')
          next unless nodes && nodes.first
          word_with_syllables_seperated = nodes.first.text
    
          pronouncations = doc.xpath('//span[@class="show_spellpr"]/span[@class="pron"]').
                               map{|a| a.text}.
                               reject{|w| w =~ /,|;/}

          phonemes = Lexicon.how_do_i_pronounce(word)

          data = {:word => word,
                  :syllables => word_with_syllables_seperated,
                  :pronouncations => pronouncations,
                  :phonemes => phonemes}

          file_to_log = !phonemes ? error_log : word_log
          file_to_log.write(data.to_json + "\n")
          file_to_log.flush          
         rescue
           puts "#{word} lookup failed: #{$!}"
         end
        end
      end
    end

    puts File.expand_path(File.dirname(__FILE__) + '/../') + '/tmp/lookup.json'
  end
end