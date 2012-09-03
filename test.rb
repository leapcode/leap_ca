#!/usr/bin/ruby

require 'rubygems'
require 'yajl/http_stream'
require 'lib/couch_stream'
require 'lib/couch_changes'


def main
# TODO: read the connection from a config
  couch = CouchStream.new("http://localhost:5984/", "salticidae_certs")
  changes = CouchChanges.new(couch)
  changes.follow do |hash|
    p hash
  end
end

main
