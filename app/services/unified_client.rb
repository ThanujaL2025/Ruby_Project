require 'httparty'

class UnifiedClient
  include HTTParty
  base_uri 'https://api.unified.to/v1'

  def initialize
    @headers = {
      "Authorization" => "Bearer #{Rails.application.config.x.unified_api_key}",
      "Content-Type" => "application/json"
    }
  end

  def list_providers
    self.class.get("/providers", headers: @headers)
  end
end
