#!/usr/bin/ruby

require 'rubygems'
require "yajl/http_stream"

def main
  url = "http://localhost:5984/"
  db = "leap_certs"
  feed_type = "continuous"
  since = "0"
  queue = "changes"
  
  Yajl::HttpStream.get("#{url}#{db}/_changes?feed=#{feed_type}&since=#{since}", :symbolize_keys => true) do |hash|
    if hash[:id]
      p hash
    end
  end
end

main
