$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "search_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "search_client"
  s.version     = SearchClient::VERSION
  s.authors     = ["William Ross"]
  s.email       = ["will@spanner.org"]
  s.homepage    = "https://github.com/spanner/search_client"
  s.summary     = "Provides SDK-level access to the Croucher Foundation search API."
  s.description = "For now just a convenience and maintenance simplifier."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "her"
  s.add_dependency "faraday"
  s.add_dependency "faraday_middleware"



  s.add_development_dependency "sqlite3"
end
