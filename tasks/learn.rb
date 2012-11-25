module Creative::Machine
namespace :learn do
  haikus_rankings = [
    {["on the cherry glass",  "even worn lost rain of all",      "and it looks not the"]    => 1},
    {["after all sign far",   "see tide under just end am",      "the rice many am"]        => 1},
    {["being cherry the",     "amid hair rain harvest the",      "of shelter to why"]       => 1},
    {["of white inscription", "have the to the youth coming",    "not very her at"]         => 1},
    {["ugly bend radish",     "warriors is our autumn",          "take needles shoots the"] => 1},
    {["dripping morning snow","rain violets are striking",       "autumn bites day fresh"]  => 3},
    {["misty chestnut moon",  "wild embrace that changes night", "like heat on the snow"]   => 6}
  ]
  
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
    tlearn = TLearn::Run.new(PoetEngine::NeuralNetwork.config)
    lexicon = PoetEngine::Lexicon.new
    poem_encoder = PoetEngine::NeuralNetwork::PoemEncoder.new(lexicon)
    
    haikus = haikus_rankings.map{|haiku_hash| Haiku.new(tokenise_haiku(haiku_hash.keys[0]))}

    encoded_haikus = haikus.map {|haiku| poem_encoder.encode(haiku)}
    
    index = 0 
    data = encoded_haikus.map do |encoded_syllables| 
      rank = haikus_rankings[index].values[0]
      index += 1
      encoded_syllables.map {|encoded_syllable| {|encoded_syllable => rank_to_array(rank)}}
    end

    tlearn.train(data, iterations = 2000, working_dir = 'data/weights/')
  end
end
end