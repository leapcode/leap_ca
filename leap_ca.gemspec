$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "leap_ca/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "leap_ca"
  s.version     = LeapCA::VERSION
  s.authors     = ["Azul"]
  s.email       = ["azul@leap.se"]
  s.homepage    = "http://www.leap.se"
  s.summary     = "CA deamon for the leap platform"
  s.description = "This deamon refills the pool of client certs for the leap platform. They are stored in a CouchDB instance and can be handed out with a webservice."

  s.files = Dir["{config,lib}/**/*", 'bin/*'] + ["Rakefile", "Readme.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "couchrest", "~> 1.1.3"
  s.add_dependency "couchrest_model", "~> 2.0.0.beta2"
  s.add_dependency "daemons"
  s.add_dependency "yajl-ruby"
  s.add_development_dependency "minitest", "~> 3.2.0"
  s.add_development_dependency "mocha"

end
