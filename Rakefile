$:.unshift(File.dirname(__FILE__) + '/lib') unless $:.include?(File.dirname(__FILE__) + '/lib')

require 'rubygems'
require 'rspec/core/rake_task'

require 'creative_machine'

desc "integration tests"
RSpec::Core::RakeTask.new(:spec_integration) do |t|
  t.pattern = 'spec_integration/**/*_spec.rb'
  t.rcov_opts =  %[-Ilib -Ispec --sort coverage --aggregate coverage.data]
end

desc "unit tests"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rcov_opts =  %[-Ilib -Ispec  --sort coverage --aggregate coverage.data]
end

Dir[File.dirname(__FILE__) + '/tasks/*.rb'].each {|task| require task }

task :default => [:spec, :spec_integration]

namespace :art do
  desc "Write a Haiku"
  task :haiku do
    poet = Creative::Machine::Poet.new
    poems = poet.evolve()
    puts poems[0]
  end
end

namespace :learn do
  task :start do
    require 'tlearn'
    tlearn = TLearn::Run.new(Creative::Machine::PoetEngine::NeuralNetwork.config)

    poem_encoder = Creative::Machine::PoetEngine::NeuralNetwork::PoemEncoder.new(Creative::Machine::PoetEngine::Lexicon.new)

    test_haiku = Creative::Machine::Haiku.new([[%W{on the cherry glass}],
                                               [%W{even worn lost rain of all}],
                                               [%W{and it looks not the}]])

    haikus ||= [test_haiku]

    data = haikus.map { |haiku| poem_encoder.encode(haiku) }
    data = data.map { |haiku| {haiku => [1, 0, 0, 0, 0, 0]} }

    tlearn.train(data, 100, working_dir = 'data/weights/')
  end
end