require "admiral"
require "crest"
require "json"

require "./tiktoker/*"

module TikToker
  class_getter config = Configuration.new

  def self.run
    TikToker::CLI.run
  end
end
