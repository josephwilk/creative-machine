module Creative
  module Machine
    module PoetEngine
      class Phonemes
        class InvalidPhoneme < Exception; end;
        
        PHONEMES_FILE = File.dirname(__FILE__) + '/../../../../data/phonemeicon.json'
        
        def self.lookup(phone)
  	      @data ||= JSON.parse(File.read(PHONEMES_FILE))
  	      meta_data = @data[phone]
          raise InvalidPhoneme.new("Invalid phone: [#{phone}]") unless meta_data
          meta_data
        end
      end
    end
  end
end