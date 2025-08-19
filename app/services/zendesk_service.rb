require 'httparty'

class ZendeskService
  BASE_URL = "https://api.unified.to"

  def initialize(connection_id)
    @connection_id = connection_id
  end

  # Step 6: Implement API call to Unified.to endpoint (following tutorial pattern)
  def get_employees
    response = HTTParty.get(
      "#{BASE_URL}/hris/#{@connection_id}/employee",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
      },
      query: {
        fields: "id,created_at,updated_at,name,emails,telephones,image_url,timezone,employee_number,employment_status,language_locale,employee_roles"
      }
    )
    
    # Handle HTTP response status
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "http_code" => response.code,
        "raw_response" => response.body
      }
    end
  end

  def get_tickets
    response = HTTParty.get(
      "#{BASE_URL}/ticketing/#{@connection_id}/tickets",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "http_code" => response.code,
        "raw_response" => response.body
      }
    end
  end

  def get_contacts
    response = HTTParty.get(
      "#{BASE_URL}/crm/#{@connection_id}/contacts",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
        }
      )
    
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "raw_response" => response.body
      }
    end
  end

  def get_companies
    response = HTTParty.get(
      "#{BASE_URL}/crm/#{@connection_id}/companies",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "raw_response" => response.body
      }
    end
  end

  def create_ticket(ticket_data)
    response = HTTParty.post(
      "#{BASE_URL}/ticketing/#{@connection_id}/tickets",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}",
        "Content-Type" => "application/json"
      },
      body: ticket_data.to_json
    )
    
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "raw_response" => response.body
      }
    end
  end

  # Additional methods following tutorial pattern
  def get_candidates
    response = HTTParty.get(
      "#{BASE_URL}/ats/#{@connection_id}/candidate",
      headers: {
        "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
      },
      query: {
        limit: 20,
        offset: 0
      }
    )
    
    if response.success?
      response.parsed_response
    else
      {
        "statusCode" => response.code,
        "error" => response.code == 401 ? "Unauthorized" : "Request Failed",
        "message" => response.message || "HTTP #{response.code}",
        "raw_response" => response.body
      }
    end
  end
end
