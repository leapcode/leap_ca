require 'couchrest_model'

class Cert < CouchRest::Model::Base

  use_database 'certs'

  timestamps!

  property :random, Float, :accessible => false

  before_validation :set_random, :attach_zip, :on => :create

  validates :random, :presence => true,
    :numericality => {:greater_than => 0, :less_than => 1}

  validates :zip_attachment, :presence => true

  design do
  end

  def set_random
    self.random = rand
  end

  def attach_zip
    file = File.open File.join(LEAP_CA_ROOT, "config", "cert")
    self.create_attachment :file => file, :name => zipname
  end

  def zipname
    'cert.txt'
  end

  def zip_attachment
    attachments[zipname]
  end

  def zipped
    read_attachment(zipname)
  end

end
