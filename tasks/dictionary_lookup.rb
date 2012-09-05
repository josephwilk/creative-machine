require 'nokogiri'
require 'open-uri'
require 'json'

desc "map words to syllables/pronuciation/emphasis"
task :create_dictionary_lookup do
  URL = 'http://dictionary.reference.com/browse'

  word_data = []

  words = File.read(File.dirname(__FILE__) + '/../data/haiku.txt')
  words = words.split(' ').
                reject {|word| word =~ /-|--/}.
                map{|word| word.downcase}.
                map{|word| word.gsub(/[^\w\d]/, '')}

  words[0..10].each do |word|
    doc = Nokogiri::HTML(open("#{URL}/#{URI.escape(word)}"))

    word_with_syllables_seperated = doc.xpath('//h2[@class="me"]').first.text
    
    pronouncations = doc.xpath('//span[@class="show_spellpr"]/span[@class="pron"]').
                         map{|a| a.text}.
                         reject{|w| w =~ /,/}


    json = {:word => word,
            :syllables => word_with_syllables_seperated,
            :pronouncations => pronouncations}

    word_data << json

    File.open(File.dirname(__FILE__) + '/../tmp/lookup.json', 'w'){|f| f.write(word_data.to_json)}
  end

end