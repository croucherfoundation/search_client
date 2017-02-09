module SearchClientHelper

  def search_url(path)
    URI.join(search_host, path).to_s
  end

  def search_host
    Settings.search[:protocol] ||= 'http'
    "#{Settings.search.protocol}://#{Settings.search.api_host}"
  end

end
