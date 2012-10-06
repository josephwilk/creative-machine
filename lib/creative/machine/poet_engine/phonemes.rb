module Creative
  module Machine
    module PoetEngine
      class Phonemes
        PHONEMES_FILE = File.dirname(__FILE__) + '/../../../../data/phonemeicon.json'
        
        def self.lookup(phone)
  	      @data ||= JSON.parse(File.read(PHONEMES_FILE))
  	      @data[phone]
        end
      end
    end
  end
end