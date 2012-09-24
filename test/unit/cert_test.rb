require 'test_helper'
require 'leap_ca/cert'

class CertTest < MiniTest::Unit::TestCase

  def setup
    @sample = Cert.new
    @sample.set_random
    @sample.attach_zip
  end

  def test_certs_come_with_attachments
    assert @sample.has_attachment? "cert.txt"
  end

  def test_zipper_returns_zip_attachement
    assert_equal "text/plain", @sample.zip_attachment["content_type"]
  end

  def test_zipname_returns_name_of_zip_file
    assert_equal "cert.txt", @sample.zipname
  end

  def test_test_data
    assert @sample.valid?
  end

  def test_zipped_returns_actual_data
    @sample.save # This is required!
    lines = @sample.zipped.split("\n")
    assert_equal 56, lines.count
    assert_equal "-----BEGIN RSA PRIVATE KEY-----", lines.first.chomp
    assert_equal "-----END CERTIFICATE-----", lines.last.chomp
  end

  def test_validation_of_random
    @sample.stubs(:set_random)
    [0, 1, nil, "asdf"].each do |invalid|
      @sample.random = invalid
      assert !@sample.valid?, "#{invalid} should not be a valid value for random"
    end
  end

  def test_validation_of_attachement
    @sample.stubs(:attach_zip)
    @sample.delete_attachment(@sample.zipname)
    assert !@sample.valid?, "Cert should require zipped attachment"
  end

end
