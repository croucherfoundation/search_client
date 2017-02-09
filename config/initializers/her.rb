require 'settings'
require 'faraday_middleware'
require 'her'
require 'her/middleware/json_api_parser'

Settings.search ||= {}
Settings.search[:protocol] ||= 'http'
Settings.search[:api_host] ||= Settings.search[:host] || 'localhost'
Settings.search[:api_port] ||= Settings.search[:port] || 8010

SEARCH_API = Her::API.new
SEARCH_API.setup url: "#{Settings.search.protocol}://#{Settings.search.api_host}:#{Settings.search.api_port}" do |c|
  # Request
  c.use FaradayMiddleware::EncodeJson
  # Response
  c.use Her::Middleware::JsonApiParser
  c.use Faraday::Adapter::NetHttp
end
