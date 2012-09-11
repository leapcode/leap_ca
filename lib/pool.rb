require 'yaml'

module LeapCA
  class Pool
    def initialize(filename)
      @config = YAML.load(File.open(filename, 'r'))
    end

    def fill
      while Cert.count < self.size do
        Cert.create!
      end
    end

    def size
      @config[:size] ||= 10
    end
  end
end
