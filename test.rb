#!/usr/bin/ruby

require 'rubygems'
require "yajl/http_stream"

class CouchStream
  def initialize(server, db)
    @server = server
    @db = db
  end

  def get(path, options)
    url = url_for(path, options)
    # puts url
    Yajl::HttpStream.get(url, :symbolize_keys => true) do |hash|
      yield(hash)
    end
  end

  def url_for(path, options)
    url = @server + @db + '/' + path
    url += '?' if options.any?
    url += options.map {|k,v| "#{k}=#{v}"}.join('&')
  end
end

class CouchChanges
  def initialize(stream)
    @stream = stream
  end

  def last_seq
    @stream.get "_changes", :limit => 1, :descending => true do |hash|
      return hash[:last_seq]
    end
  end

  def follow
    @stream.get "_changes", :feed => :continuous, :since => last_seq do |hash|
      yield(hash)
    end
  end
end

def main
# TODO: read the connection from a config
  couch = CouchStream.new("http://localhost:5984/", "salticidae_certs")
  changes = CouchChanges.new(couch)
  changes.follow do |hash|
    p hash
  end
end

main
