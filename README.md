LEAP Certificate Authority Daemon
---------------------------------------------------

``leap_ca_daemon`` is a background daemon that generates x509 certificates as needed and stores them in CouchDB. You can run ``leap_ca`` on a machine that is not connected to a network, and then periodically connect to sync up the cert database.

* Its only interface with the outside world is a CouchDB connection (defaults to localhost).
* The daemon monitors changes to the database and fills it with x509 certs as needed.
* It requires access to a Certificate Authority (in other words, the RSA private key and x509 root certificate, in PEM format).

This program is written in Ruby and is distributed under the following license:

> GNU Affero General Public License
> Version 3.0 or higher
> http://www.gnu.org/licenses/agpl-3.0.html

Installation
---------------------

Prerequisites:

    sudo apt-get install ruby ruby-dev couchdb
    # if you are running ruby 1.8, you will also need rubygems.
    # for development, you will also need git, bundle, and rake.

From source:

    git clone git://leap.se/leap_ca
    cd cleap_ca
    bundle
    rake build
    sudo rake install

From gem:

    sudo gem install leap_ca

Running
--------------------

See if it worked:

    leap_ca_daemon run -- test/config/config.yaml
    browse to http://localhost:5984/_utils

How you would run normally in production mode:

    leap_ca_daemon start
    leap_ca_daemon stop

See ``leap_ca_daemon --help`` for more options.

Configuration
---------------------

``leap_ca_daemon`` reads the following configurations files, in this order:

* ``$(leap_ca_source)/config/default_config.yaml``
* ``/etc/leap/leap_ca.yaml``
* Any file passed to ARGV like so ``leap_ca start -- /etc/leap_ca.yaml``

Other than ``ca_key_path`` and ``ca_cert_path`` you can probably leave all other options at their default values.

The default options are:

    #
    # Default configuration options for LEAP Certificate Authority Daemon
    #

    #
    # Certificate Authority
    #
    ca_key_path: "../test/files/ca.key"
    ca_key_password: nil
    ca_cert_path: "../test/files/ca.crt"

    #
    # Certificate pool
    #
    max_pool_size: 100
    client_cert_lifespan: 2
    client_cert_bit_size: 2024
    client_cert_hash: "SHA256"

    #
    # Database
    #
    db_name: "client_certificates"
    couch_connection:
      protocol: "http"
      host: "localhost"
      port: 5984
      username: ~
      password: ~
      prefix: ""
      suffix: ""

Rake Tasks
----------------------------

    rake -T
    rake build      # Build leap_ca-x.x.x.gem into the pkg directory
    rake install    # Install leap_ca-x.x.x.gem into either system-wide or user gems
    rake test       # Run tests
    rake uninstall  # Uninstall leap_ca-x.x.x.gem from either system-wide or user gems

Development
--------------------

For development and debugging you might want to run the programm directly without
the deamon wrapper. You can do this like this:

    ruby -I lib lib/leap_ca_daemon.rb


Todo
----------------------------

* Remove deprecated 'yajl/http_stream'
