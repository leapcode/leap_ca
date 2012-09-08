require 'couchrest_model'

class Cert < CouchRest::Model::Base

  use_database 'certs'

  timestamps!

  property :random, Float, :accessible => false

  before_validation :set_random, :attach_zip, :on => :create

  validates :random, :presence => true,
    :numericality => {:greater_than => 0, :less_than => 1}

  validates :zipped, :presence => true

  def set_random
    self.random = rand
  end

  def attach_zip
    self.create_attachment :file => StringIO.new("dummy cert"), :name => zipname
  end

  def zipname
    'cert.zip'
  end

  def zipped
    attachments[zipname]
  end

end
