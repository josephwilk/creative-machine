$:.unshift(File.dirname(__FILE__) + '/lib') unless $:.include?(File.dirname(__FILE__) + '/lib')

require 'creative_machine'

RSpec.configure do |c|
  c.before(:all) do
    root = File.dirname(__FILE__) + '/../'
    FileUtils.cp("#{root}/spec_integration/fixtures/*", "#{root}/data/weights/")
  end
end