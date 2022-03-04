require 'settings'
require 'faraday_middleware'
require 'her'
require 'her/middleware/json_api_parser'

api_url = ENV['SEARCH_API_URL']

SEARCH_API = Her::API.new
SEARCH_API.setup url: api_url do |c|
  # Request
  c.use FaradayMiddleware::EncodeJson
  # Response
  c.use Her::Middleware::JsonApiParser
  c.adapter Faraday::Adapter::NetHttp
end
