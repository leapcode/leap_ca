unless defined? BASE_DIR
  BASE_DIR = File.expand_path('../..', __FILE__)
end
unless defined? LEAP_CA_CONFIG
  LEAP_CA_CONFIG = '/etc/leap/leap_ca.yaml'
end

#
# Load Config
# this must come first, because CouchRest needs the connection defined before the models are defined.
#
require 'leap_ca/config'
LeapCA::Config.load(BASE_DIR, 'config/config_default.yaml', LEAP_CA_CONFIG, ARGV.grep(/\.ya?ml$/).first)

require 'couchrest_model'
CouchRest::Model::Base.configure do |config|
  config.connection = LeapCA::Config.couch_connection
end

#
# Load LeapCA
#
require 'leap_ca/cert'
require 'leap_ca/couch_stream'
require 'leap_ca/couch_changes'
require 'leap_ca/pool'
