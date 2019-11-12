$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "api_client/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "api_client"
  s.version     = ApiClient::VERSION
  s.authors       = ["SBL"]
  s.email         = ["ops@superbeinglabs.org"]
  s.summary       = %q{Generic API Client}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rest-client", ">= 2.0.2", "< 2.2.0"
end
