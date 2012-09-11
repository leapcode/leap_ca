#!/usr/bin/ruby

require 'rubygems'
require 'yajl/http_stream'
require 'lib/cert'
require 'lib/couch_stream'
require 'lib/couch_changes'


def main
  puts "Tracking #{Cert.database.root}"
  couch = CouchStream.new(Cert.database.root)
  changes = CouchChanges.new(couch)
  changes.follow do |hash|
    p hash
  end
end

main
