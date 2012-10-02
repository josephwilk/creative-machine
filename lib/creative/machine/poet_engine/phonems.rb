module Creative
  module Machine
    module PoetEngine
      class Phonems
        PHONEMS_FILE = File.dirname(__FILE__) + '/../../../../data/phonemicon.json'
        
        def self.lookup(phone)
  	      @data ||= JSON.parse(File.read(PHONEMS_FILE))
  	      @data[phone]
        end
      end
    end
  end
end