class IntegrationsController < ApplicationController
  def index
    # Just render the page - the widget will handle the integration
  end

  def test_connection
    connection_id = params[:connection_id]
    
    begin
      # Test multiple Unified.to endpoints to see which one works
      test_results = {}
      
      # Test 1: HRIS Employee endpoint (correct pattern from API Explorer!)
      response1 = HTTParty.get(
        "https://api.unified.to/hris/#{connection_id}/employee",
        headers: {
          "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
        },
        query: {
          fields: "id,created_at,updated_at,name,emails,telephones,image_url,timezone,employee_number,employment_status,language_locale,employee_roles"
        }
      )
      test_results[:hris_employee] = response1.code
      
      # Test 2: Ticketing tickets endpoint (correct pattern)
      response2 = HTTParty.get(
        "https://api.unified.to/ticketing/#{connection_id}/tickets",
        headers: {
          "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
        }
      )
      test_results[:ticketing_tickets] = response2.code
      
      # Test 3: CRM contacts endpoint (correct pattern)
      response3 = HTTParty.get(
        "https://api.unified.to/crm/#{connection_id}/contacts",
        headers: {
          "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
        }
      )
      test_results[:crm_contacts] = response3.code
      
      # Test 4: ATS candidates endpoint (from documentation)
      response4 = HTTParty.get(
        "https://api.unified.to/ats/#{connection_id}/candidate",
        headers: {
          "Authorization" => "Bearer #{ENV['UNIFIED_API_KEY']}"
        }
      )
      test_results[:ats_candidates] = response4.code
      
      # Check which endpoints work
      working_endpoints = test_results.select { |k, v| v == 200 }
      
      if working_endpoints.any?
        render json: { 
          success: true, 
          message: "Connection working! Working endpoints: #{working_endpoints.keys.join(', ')}",
          details: test_results
        }
      else
        render json: { 
          success: false, 
          message: "All endpoints failed. Status codes: #{test_results}",
          details: test_results
        }
      end
    rescue => e
      render json: { 
        success: false, 
        message: "Error testing connection: #{e.message}" 
      }
    end
  end

  # Step 7: Data fetching methods (following tutorial pattern)
  def fetch_employees
    connection_id = params[:connection_id]
    
    begin
      service = ZendeskService.new(connection_id)
      response = service.get_employees
      
      # Handle Unified.to API response format (Hash with data array)
      if response && response.is_a?(Hash)
        if response['data'] && response['data'].is_a?(Array)
          render json: { 
            success: true, 
            employees: response['data'] 
          }
        elsif response['data'] && response['data'].is_a?(Hash)
          # Single employee response
          render json: { 
            success: true, 
            employees: [response['data']] 
          }
        elsif response['statusCode'] && response['statusCode'] >= 400
          # Error response
          render json: { 
            success: false, 
            message: "API Error: #{response['error']} - #{response['message']}" 
          }
        else
          # Check if response is directly an array (like from API Explorer)
          if response.is_a?(Array)
            render json: { 
              success: true, 
              employees: response 
            }
          else
            render json: { 
              success: false, 
              message: "No data found in response. Response keys: #{response.keys.join(', ')}. Full response: #{response.inspect}" 
            }
          end
        end
      elsif response && response.is_a?(Array)
        render json: { 
          success: true, 
          employees: response 
        }
      else
        render json: { 
          success: false, 
          message: "Unexpected response format: #{response.class}. Response: #{response.inspect}" 
        }
      end
    rescue => e
      render json: { 
        success: false, 
        message: "Error fetching employees: #{e.message}" 
      }
    end
  end

  def fetch_tickets
    connection_id = params[:connection_id]
    
    begin
      service = ZendeskService.new(connection_id)
      response = service.get_tickets
      
      # Handle Unified.to API response format (Hash with data array)
      if response && response.is_a?(Hash)
        if response['data'] && response['data'].is_a?(Array)
          render json: { 
            success: true, 
            tickets: response['data'] 
          }
        elsif response['data'] && response['data'].is_a?(Hash)
          # Single ticket response
          render json: { 
            success: true, 
            tickets: [response['data']] 
          }
        else
          render json: { 
            success: false, 
            message: "No data found in response. Response keys: #{response.keys.join(', ')}" 
          }
        end
      elsif response && response.is_a?(Array)
        render json: { 
          success: true, 
          tickets: response 
        }
      else
        render json: { 
          success: false, 
          message: "Unexpected response format: #{response.class}. Response: #{response.inspect}" 
        }
      end
    rescue => e
      render json: { 
        success: false, 
        message: "Error fetching tickets: #{e.message}" 
      }
    end
  end

  def fetch_contacts
    connection_id = params[:connection_id]
    
    begin
      service = ZendeskService.new(connection_id)
      response = service.get_contacts
      
      # Handle Unified.to API response format (Hash with data array)
      if response && response.is_a?(Hash)
        if response['data'] && response['data'].is_a?(Array)
          render json: { 
            success: true, 
            contacts: response['data'] 
          }
        elsif response['data'] && response['data'].is_a?(Hash)
          # Single contact response
          render json: { 
            success: true, 
            contacts: [response['data']] 
          }
        else
          render json: { 
            success: false, 
            message: "No data found in response. Response keys: #{response.keys.join(', ')}" 
          }
        end
      elsif response && response.is_a?(Array)
        render json: { 
          success: true, 
          contacts: response 
        }
      else
        render json: { 
          success: false, 
          message: "Unexpected response format: #{response.class}. Response: #{response.inspect}" 
        }
      end
    rescue => e
      render json: { 
        success: false, 
        message: "Error fetching contacts: #{e.message}" 
      }
    end
  end

  def fetch_candidates
    connection_id = params[:connection_id]
    
    begin
      service = ZendeskService.new(connection_id)
      response = service.get_candidates
      
      # Handle Unified.to API response format (Hash with data array)
      if response && response.is_a?(Hash)
        if response['data'] && response['data'].is_a?(Array)
          render json: { 
            success: true, 
            candidates: response['data'] 
          }
        elsif response['data'] && response['data'].is_a?(Hash)
          # Single candidate response
          render json: { 
            success: true, 
            candidates: [response['data']] 
          }
        else
          render json: { 
            success: false, 
            message: "No data found in response. Response keys: #{response.keys.join(', ')}" 
          }
        end
      elsif response && response.is_a?(Array)
        render json: { 
          success: true, 
          candidates: response 
        }
      else
        render json: { 
          success: false, 
          message: "Unexpected response format: #{response.class}. Response: #{response.inspect}" 
        }
      end
    rescue => e
      render json: { 
        success: false, 
        message: "Error fetching candidates: #{e.message}" 
      }
    end
  end

  # Debug method to see raw API response
  def debug_api_response
    connection_id = params[:connection_id] || '68a3859ee3ce4f6f8273b550'
    
    begin
      service = ZendeskService.new(connection_id)
      
      # Test all endpoints and show raw responses
      responses = {
        employees: service.get_employees,
        tickets: service.get_tickets,
        contacts: service.get_contacts,
        candidates: service.get_candidates
      }
      
      render json: {
        success: true,
        connection_id: connection_id,
        responses: responses,
        response_types: responses.transform_values { |r| r.class.to_s },
        response_keys: responses.transform_values { |r| r.is_a?(Hash) ? r.keys : 'N/A' }
      }
    rescue => e
      render json: {
        success: false,
        error: e.message,
        backtrace: e.backtrace.first(5)
      }
    end
  end
end
