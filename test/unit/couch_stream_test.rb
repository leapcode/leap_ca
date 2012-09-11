require 'test_helper'
require 'lib/couch_stream'

# we'll mock this
module Yajl
  class HttpStream
  end
end

class CouchStreamTest < MiniTest::Unit::TestCase

  def setup
    @config = stub(:server => "http://server", :database => "database")
    @stream = CouchStream.new(@config)
    @url = "http://server/database/_changes?c=d&a=b"
    @path = "_changes"
    @options = {:a => :b, :c => :d}
  end

  def test_get
    Yajl::HttpStream.expects(:get).
      with(@url, :symbolize_keys => true).
      yields(stub_hash = stub)
    @stream.get(@path, @options) do |hash|
      assert_equal stub_hash, hash
    end
  end

  # internal
  def test_url_creation
    assert_equal "http://server/database/", @stream.send(:url_for, "")
    assert_equal @url, @stream.send(:url_for, @path, @options)
  end

end
