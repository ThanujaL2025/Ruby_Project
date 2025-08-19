require 'httparty'

class MultiPlatformService
  BASE_URL = "https://api.unified.to"

  def initialize
    @api_key = ENV['UNIFIED_API_KEY']
  end

  # Zendesk Integration (WhatsApp users)
  def get_zendesk_tickets(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/ticketing/#{connection_id}/tickets",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "Zendesk API Error", status: response.code, message: response.message }
    end
  end

  def get_zendesk_contacts(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/ticketing/#{connection_id}/customers",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "Zendesk API Error", status: response.code, message: response.message }
    end
  end

  # HubSpot Integration (CRM + HR)
  def get_hubspot_contacts(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/crm/#{connection_id}/contacts",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "HubSpot API Error", status: response.code, message: response.message }
    end
  end

  def get_hubspot_employees(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/hris/#{connection_id}/employee",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      },
      query: {
        fields: "id,created_at,updated_at,name,emails,telephones,image_url,timezone,employee_number,employment_status,language_locale,employee_roles"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "HubSpot HR API Error", status: response.code, message: response.message }
    end
  end

  def get_hubspot_companies(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/crm/#{connection_id}/companies",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "HubSpot API Error", status: response.code, message: response.message }
    end
  end

  # Firefish Integration (YouTube users)
  def get_firefish_contacts(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/crm/#{connection_id}/contacts",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "Firefish API Error", status: response.code, message: response.message }
    end
  end

  # WhatsApp Integration (if available through Unified.to)
  def get_whatsapp_messages(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/messaging/#{connection_id}/messages",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "WhatsApp API Error", status: response.code, message: response.message }
    end
  end

  # YouTube Integration (content analytics + user data)
  def get_youtube_analytics(connection_id)
    response = HTTParty.get(
      "#{BASE_URL}/passthrough/#{connection_id}/youtube/analytics",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "YouTube API Error", status: response.code, message: response.message }
    end
  end

  # Get ALL YouTube user information from multiple HR systems
  def get_all_youtube_users_info
    all_youtube_users = {}
    
    # Get YouTube users from YouTube API
    youtube_users = get_youtube_users_from_youtube_api
    
    # For each YouTube user, collect data from all HR systems
    youtube_users.each do |youtube_user|
      user_email = youtube_user['email'] || youtube_user['channel_email']
      
      all_youtube_users[user_email] = {
        youtube_info: youtube_user,
        hr1_data: get_user_from_hr_system(user_email, 'hr1'),
        hr2_data: get_user_from_hr_system(user_email, 'hr2'),
        hr3_data: get_user_from_hr_system(user_email, 'hr3'),
        zendesk_data: get_user_from_zendesk(user_email),
        unified_profile: {}
      }
      
      # Create unified profile combining all data
      all_youtube_users[user_email][:unified_profile] = create_unified_user_profile(
        all_youtube_users[user_email]
      )
    end
    
    all_youtube_users
  end

  # Get YouTube users from YouTube API
  def get_youtube_users_from_youtube_api
    # This would get all YouTube users/subscribers
    # Implementation depends on YouTube API endpoints available through Unified.to
    response = HTTParty.get(
      "#{BASE_URL}/passthrough/#{ENV['YOUTUBE_CONNECTION_ID']}/youtube/users",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "YouTube Users API Error", status: response.code, message: response.message }
    end
  end

  # Get user data from specific HR system
  def get_user_from_hr_system(user_email, hr_system)
    connection_id = case hr_system
                   when 'hr1'
                     ENV['HR1_CONNECTION_ID']
                   when 'hr2'
                     ENV['HR2_CONNECTION_ID']
                   when 'hr3'
                     ENV['HR3_CONNECTION_ID']
                   end
    
    return { error: "No connection ID for #{hr_system}" } unless connection_id
    
    response = HTTParty.get(
      "#{BASE_URL}/hris/#{connection_id}/employee",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      },
      query: {
        fields: "id,created_at,updated_at,name,emails,telephones,image_url,timezone,employee_number,employment_status,language_locale,employee_roles",
        email: user_email
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "#{hr_system} API Error", status: response.code, message: response.message }
    end
  end

  # Get user data from Zendesk
  def get_user_from_zendesk(user_email)
    connection_id = ENV['ZENDESK_CONNECTION_ID']
    return { error: "No Zendesk connection ID" } unless connection_id
    
    response = HTTParty.get(
      "#{BASE_URL}/ticketing/#{connection_id}/customers",
      headers: {
        "Authorization" => "Bearer #{@api_key}"
      },
      query: {
        email: user_email
      }
    )
    
    if response.success?
      response.parsed_response
    else
      { error: "Zendesk API Error", status: response.code, message: response.message }
    end
  end

  # Create unified user profile from all data sources
  def create_unified_user_profile(user_data)
    unified = {
      email: user_data[:youtube_info]['email'] || user_data[:youtube_info]['channel_email'],
      name: nil,
      phone: nil,
      employment_status: nil,
      support_tickets: [],
      hr_systems: [],
      youtube_channel: user_data[:youtube_info]['channel_name'] || 'N/A'
    }
    
    # Extract name from any HR system that has it
    [user_data[:hr1_data], user_data[:hr2_data], user_data[:hr3_data]].each do |hr_data|
      if hr_data && !hr_data[:error] && hr_data['name']
        unified[:name] = hr_data['name']
        unified[:phone] = hr_data['telephones']&.first&.dig('telephone')
        unified[:employment_status] = hr_data['employment_status']
        unified[:hr_systems] << hr_data['id']
        break
      end
    end
    
    # Extract support tickets from Zendesk
    if user_data[:zendesk_data] && !user_data[:zendesk_data][:error]
      unified[:support_tickets] = user_data[:zendesk_data]['tickets'] || []
    end
    
    unified
  end

  # Unified Customer View (combine data from all platforms)
  def get_unified_customer_view(customer_email)
    # This would combine data from Zendesk, HubSpot, and Firefish
    # to create a unified customer profile
    unified_profile = {
      email: customer_email,
      zendesk_tickets: [],
      hubspot_activities: [],
      firefish_interactions: [],
      whatsapp_messages: [],
      youtube_engagement: []
    }
    
    # Implementation would depend on your specific connection IDs
    # and how you want to correlate data across platforms
    
    unified_profile
  end

  # Create ticket across platforms
  def create_cross_platform_ticket(ticket_data, platforms)
    results = {}
    
    platforms.each do |platform|
      case platform
      when 'zendesk'
        results[:zendesk] = create_zendesk_ticket(ticket_data)
      when 'hubspot'
        results[:hubspot] = create_hubspot_ticket(ticket_data)
      when 'firefish'
        results[:firefish] = create_firefish_ticket(ticket_data)
      end
    end
    
    results
  end

  private

  def create_zendesk_ticket(ticket_data)
    # Implementation for creating Zendesk tickets
  end

  def create_hubspot_ticket(ticket_data)
    # Implementation for creating HubSpot tickets
  end

  def create_firefish_ticket(ticket_data)
    # Implementation for creating Firefish tickets
  end
end
