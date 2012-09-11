#!/usr/bin/ruby

require 'rubygems'
require 'yajl/http_stream'
require 'lib/config'
require 'lib/couch_stream'
require 'lib/couch_changes'


def main
  config = LeapCA::Config.new(File.expand_path("../config.yml", __FILE__))
  p "Tracking #{config.database} on #{config.server}"
  couch = CouchStream.new(config)
  changes = CouchChanges.new(couch)
  changes.follow do |hash|
    p hash
  end
end

main
