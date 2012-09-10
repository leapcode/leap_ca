#!/usr/bin/ruby

require 'rubygems'
require 'yajl/http_stream'
require 'lib/couch_stream'
require 'lib/couch_changes'

# TODO: read the connection from a config
SERVER = "http://localhost:5984"
DATABASE = "salticidae_certs" 

def main
  couch = CouchStream.new(SERVER, DATABASE)
  changes = CouchChanges.new(couch)
  changes.follow do |hash|
    p hash
  end
end

main
