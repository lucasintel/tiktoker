require "admiral"
require "crest"
require "json"

require "./tiktoker/*"

module Tiktoker
  class_getter config = Configuration.new

  def self.run
    Tiktoker::CLI.run
  end
end
