namespace :learn do
  def haikus_rankings
    data = File.read(File.dirname(__FILE__) + '/../data/learning/ranked_haikus.json')
    JSON.parse(data)
  end
  
  def tokenise_haiku(sentences)
    sentences.map{|sentence| sentence.split(/\s/)}
  end
  
  def rank_to_array(rank)
    rank_array = [0] * 6
    rank_array[rank-1] = 1
    rank_array
  end
  
  desc 'Train the weights for the neural network'
  task :start do
    require 'tlearn'

    module Creative::Machine
      tlearn = TLearn::Run.new(PoetEngine::NeuralNetwork.config)
      lexicon = PoetEngine::Lexicon.new
      poem_encoder = PoetEngine::NeuralNetwork::PoemEncoder.new(lexicon)
    
      haiku_data = haikus_rankings.each_with_index.map do |haiku_hash, index|
        haiku = Haiku.new(tokenise_haiku(haiku_hash["haiku"]))
        encoded_syllables = poem_encoder.encode(haiku)
        encoded_syllables.map {|encoded_syllable| {encoded_syllable => rank_to_array(haiku_hash["rank"])}}
      end

      tlearn.train(haiku_data, iterations = 2000, working_dir = 'data/weights/')
    end
  end
end