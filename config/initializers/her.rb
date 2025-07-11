require 'faraday'
require 'json'
require 'her'
require 'her/middleware/json_api_parser'

api_url = ENV['SEARCH_API_URL'] || "#{Settings.search.protocol}://#{Settings.search.api_host}:#{Settings.search.api_port}"

SEARCH_API = Her::API.new
SEARCH_API.setup url: api_url do |c|
  # Request: encode JSON manually
  c.request :json

  # Response: parse JSON API
  c.use Her::Middleware::JsonApiParser

  # Adapter
  c.adapter Faraday.default_adapter
end
