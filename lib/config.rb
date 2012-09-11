require 'yaml'

module LeapCA
  class Config
    def initialize(filename)
      file = File.new(filename, 'r')
      @hash = YAML::load(file)
    end

    def server
      @hash['server']
    end

    def database
      @hash['database']
    end
  end
end
