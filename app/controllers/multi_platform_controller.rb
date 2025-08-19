class MultiPlatformController < ApplicationController
  def index
    # Display multi-platform dashboard
  end

  # Get unified customer view across all platforms
  def unified_customer_view
    customer_email = params[:email]
    
    begin
      service = MultiPlatformService.new
      unified_profile = service.get_unified_customer_view(customer_email)
      
      render json: {
        success: true,
        customer_profile: unified_profile
      }
    rescue => e
      render json: {
        success: false,
        message: "Error getting unified customer view: #{e.message}"
      }
    end
  end

  # Get data from specific platform
  def platform_data
    platform = params[:platform]
    data_type = params[:data_type]
    connection_id = params[:connection_id]
    
    begin
      service = MultiPlatformService.new
      
      case platform
      when 'zendesk'
        case data_type
        when 'tickets'
          data = service.get_zendesk_tickets(connection_id)
        when 'contacts'
          data = service.get_zendesk_contacts(connection_id)
        end
      when 'hubspot'
        case data_type
        when 'contacts'
          data = service.get_hubspot_contacts(connection_id)
        when 'employees'
          data = service.get_hubspot_employees(connection_id)
        when 'companies'
          data = service.get_hubspot_companies(connection_id)
        end
      when 'firefish'
        case data_type
        when 'contacts'
          data = service.get_firefish_contacts(connection_id)
        end
      when 'whatsapp'
        case data_type
        when 'messages'
          data = service.get_whatsapp_messages(connection_id)
        end
      when 'youtube'
        case data_type
        when 'analytics'
          data = service.get_youtube_analytics(connection_id)
        end
      end
      
      if data && !data[:error]
        render json: {
          success: true,
          platform: platform,
          data_type: data_type,
          data: data
        }
      else
        render json: {
          success: false,
          message: data[:error] || "No data found",
          platform: platform,
          data_type: data_type
        }
      end
    rescue => e
      render json: {
        success: false,
        message: "Error fetching #{data_type} from #{platform}: #{e.message}"
      }
    end
  end

  # Create ticket across multiple platforms
  def create_cross_platform_ticket
    ticket_data = params[:ticket_data]
    platforms = params[:platforms] || []
    
    begin
      service = MultiPlatformService.new
      results = service.create_cross_platform_ticket(ticket_data, platforms)
      
      render json: {
        success: true,
        message: "Ticket created across platforms",
        results: results
      }
    rescue => e
      render json: {
        success: false,
        message: "Error creating cross-platform ticket: #{e.message}"
      }
    end
  end

  # Get platform status and connection info
  def platform_status
    platforms = {
      zendesk: {
        name: "Zendesk",
        description: "Customer support for some YouTube users",
        connection_id: ENV['ZENDESK_CONNECTION_ID'],
        status: "Connected"
      },
      hr1: {
        name: "HR1",
        description: "HR system for some YouTube users",
        connection_id: ENV['HR1_CONNECTION_ID'],
        status: "Connected"
      },
      hr2: {
        name: "HR2", 
        description: "HR system for other YouTube users",
        connection_id: ENV['HR2_CONNECTION_ID'],
        status: "Connected"
      },
      hr3: {
        name: "HR3",
        description: "HR system for other YouTube users", 
        connection_id: ENV['HR3_CONNECTION_ID'],
        status: "Connected"
      },
      youtube: {
        name: "YouTube",
        description: "Content platform for all users",
        connection_id: ENV['YOUTUBE_CONNECTION_ID'],
        status: "Connected"
      }
    }
    
    render json: {
      success: true,
      platforms: platforms
    }
  end

  # Get ALL YouTube user information from all HR systems
  def all_youtube_users_info
    begin
      service = MultiPlatformService.new
      all_users = service.get_all_youtube_users_info
      
      render json: {
        success: true,
        total_users: all_users.count,
        users: all_users
      }
    rescue => e
      render json: {
        success: false,
        message: "Error getting all YouTube users info: #{e.message}"
      }
    end
  end

  # Get specific YouTube user's complete profile
  def youtube_user_profile
    user_email = params[:email]
    
    begin
      service = MultiPlatformService.new
      
      # Get user from YouTube API
      youtube_user = service.get_youtube_users_from_youtube_api.find { |u| u['email'] == user_email }
      
      if youtube_user
        user_data = {
          youtube_info: youtube_user,
          hr1_data: service.get_user_from_hr_system(user_email, 'hr1'),
          hr2_data: service.get_user_from_hr_system(user_email, 'hr2'),
          hr3_data: service.get_user_from_hr_system(user_email, 'hr3'),
          zendesk_data: service.get_user_from_zendesk(user_email)
        }
        
        unified_profile = service.create_unified_user_profile(user_data)
        
        render json: {
          success: true,
          user_profile: unified_profile,
          raw_data: user_data
        }
      else
        render json: {
          success: false,
          message: "YouTube user not found"
        }
      end
    rescue => e
      render json: {
        success: false,
        message: "Error getting YouTube user profile: #{e.message}"
      }
    end
  end
end
