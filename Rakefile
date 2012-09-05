require 'rubygems'
require 'rspec/core/rake_task'

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