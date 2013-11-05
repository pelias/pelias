require "elasticsearch"
require "json"
require "pg"

require "pelias/base"
require "pelias/address"
require "pelias/street"
require "pelias/version"

module Pelias
  # Your code goes here...

  def self.root
    File.expand_path '../..', __FILE__
  end

end
