#!/usr/bin/ruby

require 'rubygems'
require "yajl/http_stream"

def main
  url = "http://localhost:5984/"
  db = "salticidae_certs"
  feed_type = "continuous"
  since = "0"
  queue = "changes"

 # descending = true for last changes first. limit = 1  
  Yajl::HttpStream.get("#{url}#{db}/_changes?limit=1&descending=true", :symbolize_keys => true) do |hash|
    since = hash[:last_seq]
  end

  Yajl::HttpStream.get("#{url}#{db}/_changes?feed=#{feed_type}&since=#{since}", :symbolize_keys => true) do |hash|
    if hash[:id]
      p hash
    end
  end
end

main
