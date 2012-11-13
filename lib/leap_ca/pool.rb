require 'yaml'

module LeapCA
  class Pool
    def initialize(config = {:size => 10})
      @config = config
    end

    def fill
      while Cert.count < self.size do
        cert = Cert.create!
        puts " * Created client certificate #{cert.id}"
      end
    end

    def size
      @config[:size]
    end
  end
end
