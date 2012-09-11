class CouchStream
  def initialize(config)
    @config = config
  end

  def get(path, options)
    url = url_for(path, options)
    # puts url
    Yajl::HttpStream.get(url, :symbolize_keys => true) do |hash|
      yield(hash)
    end
  end

  protected

  def url_for(path, options = {})
    url = [@config.server, @config.database, path].join('/')
    url += '?' if options.any?
    url += options.map {|k,v| "#{k}=#{v}"}.join('&')
  end
end
