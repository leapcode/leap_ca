#!/usr/bin/ruby

require 'rubygems'
require 'daemons'
require 'yajl/http_stream'

require 'lib/cert'
require 'lib/couch_stream'
require 'lib/couch_changes'
require 'lib/pool'


puts "Tracking #{Cert.database.root}"
couch = CouchStream.new(Cert.database.root)
changes = CouchChanges.new(couch)
pool = LeapCA::Pool.new(File.expand_path("../config/pool.yml", __FILE__))
pool.fill
Daemons.run_proc('leap_ca.rb') do
  changes.follow do |hash|
    p hash
    if hash[:deleted]
      pool.fill
    end
  end
end
