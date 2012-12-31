$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "leap_ca/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "leap_ca"
  s.version     = LeapCA::VERSION
  s.authors     = ["Azul"]
  s.email       = ["azul@leap.se"]
  s.homepage    = "https://leap.se"
  s.summary     = "Certificate Authority deamon for the LEAP Platform"
  s.description = "Provides the executable leap_ca, a deamon that refills a pool of x509 client certs stored in CouchDB."

  s.files = Dir["{config,lib}/**/*", 'bin/*'] + ["Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]
  s.bindir = 'bin'
  s.executables << 'leap_ca_daemon'

  s.add_dependency "couchrest", "~> 1.1.3"
  s.add_dependency "couchrest_model", "~> 2.0.0.beta2"
  s.add_dependency "daemons"
  s.add_dependency "yajl-ruby"
  s.add_dependency "certificate_authority"
  s.add_development_dependency "minitest", "~> 3.2.0"
  s.add_development_dependency "mocha"
  s.add_development_dependency "rake"
  s.add_development_dependency "highline"
end
