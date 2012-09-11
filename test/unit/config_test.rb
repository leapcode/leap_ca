require 'test_helper'
require 'lib/config'

class ConfigTest < MiniTest::Unit::TestCase

  def setup
    @config = LeapCA::Config.new(File.expand_path("../config.yml", __FILE__))
  end

  def test_initial_content
    assert_equal 'test-server', @config.server
    assert_equal 'test-db', @config.database
  end
end
