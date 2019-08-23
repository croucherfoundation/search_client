module SearchClientHelper

  def search_url
    ENV['SEARCH_URL'] || "#{Settings.search.protocol}://#{Settings.search.host}"
  end

end
