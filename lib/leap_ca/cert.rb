#
# Model for certificates stored in CouchDB.
#
# This file must be loaded after Config has been loaded.
#

require 'base64'
require 'digest/md5'
require 'openssl'
require 'certificate_authority'
require 'date'

module LeapCA
  class Cert < CouchRest::Model::Base

    use_database LeapCA::Config.db_name

    timestamps!

    property :key, String                          # the client private RSA key
    property :cert, String                         # the client x509 certificate, signed by the CA
    property :valid_until, Time                    # expiration time of the client certificate
    property :random, Float, :accessible => false  # used to help pick a random cert by the webapp

    validates :key, :presence => true
    validates :cert, :presence => true
    validates :random, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than => 1}

    before_validation :generate, :set_random, :on => :create

    design do
      view :by_random
    end

    class << self
      def sample
        self.by_random.startkey(rand).first || self.by_random.first
      end

      def pick_from_pool
        cert = self.sample
        raise RECORD_NOT_FOUND unless cert
        cert.destroy
        return cert
      rescue RESOURCE_NOT_FOUND
        retry if self.by_random.count > 0
        raise RECORD_NOT_FOUND
      end
    end

    #
    # generate the private key and client certificate
    #
    def generate
      cert = CertificateAuthority::Certificate.new

      # set subject
      cert.subject.common_name = random_common_name

      # set expiration
      self.valid_until = months_from_yesterday(Config.client_cert_lifespan)
      cert.not_before  = yesterday
      cert.not_after   = self.valid_until

      # generate key
      cert.serial_number.number = cert_serial_number
      cert.key_material.generate_key(Config.client_cert_bit_size)

      # sign
      cert.parent = Cert.root_ca
      cert.sign! client_signing_profile

      self.key  = cert.key_material.private_key.to_pem
      self.cert = cert.to_pem
    end

    private

    def set_random
      self.random = rand
    end

    def self.root_ca
      @root_ca ||= begin
        crt = File.read(Config.ca_cert_path)
        key = File.read(Config.ca_key_path)
        openssl_cert = OpenSSL::X509::Certificate.new(crt)
        cert = CertificateAuthority::Certificate.from_openssl(openssl_cert)
        cert.key_material.private_key = OpenSSL::PKey::RSA.new(key, Config.ca_key_password)
        cert
      end
    end

    #
    # For cert serial numbers, we need a non-colliding number less than 160 bits.
    # md5 will do nicely, since there is no need for a secure hash, just a short one.
    # (md5 is 128 bits)
    #
    def cert_serial_number
      Digest::MD5.hexdigest("#{rand(10**10)} -- #{Time.now}").to_i(16)
    end

    #
    # for the random common name, we need a text string that will be unique across all certs.
    # ruby 1.8 doesn't have a built-in uuid generator, or we would use SecureRandom.uuid
    #
    def random_common_name
      cert_serial_number.to_s(36)
    end

    def client_signing_profile
      {
        "digest" => Config.client_cert_hash,
        "extensions" => {
          "keyUsage" => {
            "usage" => ["digitalSignature"]
          },
          "extendedKeyUsage" => {
            "usage" => ["clientAuth"]
          }
        }
      }
    end

    ##
    ## TIME HELPERS
    ##
    ## note: we use 'yesterday' instead of 'today', because times are in UTC, and some people on the planet
    ## are behind UTC.
    ##

    def yesterday
      t = Time.now - 24*24*60
      Time.utc t.year, t.month, t.day
    end

    def months_from_yesterday(num)
      t = yesterday
      date = Date.new t.year, t.month, t.day
      date = date >> num  # >> is months in the future operator
      Time.utc date.year, date.month, date.day
    end

  end
end
