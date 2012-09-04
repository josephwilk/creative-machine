$:.unshift(File.dirname(__FILE__) + '/') unless $:.include?(File.dirname(__FILE__) + '/')

module Creative
  module Machine
  end
end

require 'creative/machine/poet'