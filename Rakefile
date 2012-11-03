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
    tlearn = TLearn::Run.new({})

    data = [[]]

    tlearn.train(data)
  end
end