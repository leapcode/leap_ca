require File.expand_path('../../test_helper.rb', __FILE__)

class CertTest < MiniTest::Unit::TestCase

  def setup
    @cert = LeapCA::Cert.new
  end

  def test_generate
    @cert.generate

    assert @cert.cert, 'certificate should exist'
    assert @cert.key, 'key should exist'

    ca   = OpenSSL::X509::Certificate.new(File.read(LeapCA::Config.ca_cert_path))
    cert = OpenSSL::X509::Certificate.new(@cert.cert)
    key  = OpenSSL::PKey::RSA.new(@cert.key)

    assert cert.verify(ca.public_key), "cert was not signed by CA"
    assert_equal ca.subject.to_s, cert.issuer.to_s, 'issuer should match'
    assert_equal "test", cert.public_key.public_decrypt(key.private_encrypt("test")), 'keypair should be able to encrypt/decrypt'
  end

  def test_validation_of_random
    @cert.stubs(:set_random)
    [1, nil, "asdf"].each do |invalid|
      @cert.random = invalid
      assert !@cert.valid?, "#{invalid} should not be a valid value for random"
    end
  end

end