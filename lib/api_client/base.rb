require 'api_client/core.rb'
require 'api_client/http.rb'

module Api
  module Client
    class Base
      include Core
      include Http
    end
  end
end