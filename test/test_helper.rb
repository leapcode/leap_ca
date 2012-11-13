require 'rubygems'
require 'minitest/autorun'

BASE_DIR = File.expand_path('../..', __FILE__)
$:.unshift File.expand_path('lib', BASE_DIR)

require 'mocha/setup'

LEAP_CA_CONFIG = "test/config/config.yaml"
require 'leap_ca'
