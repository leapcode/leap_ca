require 'yaml'

module LeapCA
  module Config
    extend self

    attr_accessor :ca_key_path
    attr_accessor :ca_key_password
    attr_accessor :ca_cert_path

    attr_accessor :max_pool_size
    attr_accessor :client_cert_lifespan
    attr_accessor :client_cert_bit_size
    attr_accessor :client_cert_hash

    attr_accessor :db_name
    attr_accessor :couch_connection

    def self.load(base_dir, *configs)
      configs.each do |file_path|
        file_path = find_file(base_dir, file_path)
        next unless file_path
        puts " * Loading configuration #{file_path}"
        yml = YAML.load(File.read(file_path))
        if yml
          yml.each do |key, value|
            begin
              if value.is_a? Hash
                value = symbolize_keys(value)
              end
              self.send("#{key}=", value)
            rescue NoMethodError => exc
              STDERR.puts "ERROR in file #{file}, '#{key}' is not a valid option"
              exit(1)
            end
          end
        end
      end
      [:ca_key_path, :ca_cert_path].each do |attr|
        path = self.send(attr) || ""
        if path =~ /^\./
          path = File.expand_path(path, base_dir)
          self.send("#{attr}=", path)
        end
        unless File.exists?(path)
          STDERR.puts "ERROR: The config option '#{attr}' is set to '#{path}', but the file does not exist!"
          exit(1)
        end
      end
    end

    private

    def self.find_file(base_dir, file_path)
      return nil unless file_path
      if defined? CWD
        return File.expand_path(file_path, CWD)  if File.exists?(File.expand_path(file_path, CWD))
      end
      return File.expand_path(file_path, base_dir) if File.exists?(File.expand_path(file_path, base_dir))
      return nil
    end

    def self.symbolize_keys(hsh)
      newhsh = {}
      hsh.keys.each do |key|
        newhsh[key.to_sym] = hsh[key]
      end
      newhsh
    end
  end
end
