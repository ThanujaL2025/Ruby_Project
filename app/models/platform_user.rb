class PlatformUser < ApplicationRecord
  # Validations
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :platform_source, presence: true
  validates :email, uniqueness: { scope: :platform_source }
  
  # Associations
  belongs_to :integration, optional: true
  
  # Scopes
  scope :demo_users, -> { where(is_demo_user: true) }
  scope :by_platform, ->(platform) { where(platform_source: platform) }
  scope :active, -> { where('last_seen_at > ?', 30.days.ago) }
  
  # Platform sources
  PLATFORM_SOURCES = %w[zendesk hr1 hr2 hr3 youtube hubspot firefish].freeze
  
  # Methods
  def full_name
    name.presence || email.split('@').first.titleize
  end
  
  def avatar_url
    if platform_data&.dig('image_url').present?
      platform_data['image_url']
    else
      "https://ui-avatars.com/api/?name=#{CGI.escape(full_name)}&background=random&size=100"
    end
  end
  
  def platform_icon
    case platform_source
    when 'zendesk'
      '🎫'
    when 'hr1', 'hr2', 'hr3'
      '👥'
    when 'youtube'
      '📺'
    when 'hubspot'
      '🏢'
    when 'firefish'
      '🐟'
    else
      '👤'
    end
  end
  
  def has_hr_data?
    %w[hr1 hr2 hr3].include?(platform_source)
  end
  
  def has_support_data?
    platform_source == 'zendesk'
  end
  
  def employment_info
    return nil unless has_hr_data?
    
    {
      status: employment_status,
      department: department,
      job_title: job_title
    }
  end
  
  def support_tickets_count
    return 0 unless has_support_data?
    
    # Return from platform_data if available
    platform_data&.dig('tickets_count') || 0
  end
  
  def last_activity
    last_seen_at || updated_at
  end
  
  def is_active?
    last_activity > 7.days.ago
  end
  
  def demo_user?
    is_demo_user
  end
  
  def update_unified_profile(profile_data)
    update!(
      unified_profile: profile_data,
      last_seen_at: Time.current
    )
  end
  
  def merge_platform_data(new_data)
    existing_data = platform_data || {}
    merged_data = existing_data.merge(new_data)
    
    update!(
      platform_data: merged_data,
      last_seen_at: Time.current
    )
  end
  
  # Class methods
  def self.find_or_create_from_platform(email, platform, data = {})
    user = find_or_initialize_by(email: email, platform_source: platform)
    
    user.assign_attributes(
      name: data['name'] || data[:name],
      phone: data['telephones']&.first&.dig('telephone') || data['phone'],
      employment_status: data['employment_status'],
      department: data['department'],
      job_title: data['job_title'],
      platform_data: data,
      last_seen_at: Time.current
    )
    
    user.save!
    user
  end
  
  def self.create_demo_users
    demo_data = [
      {
        email: 'john.doe@abc.com',
        name: 'John Doe',
        platform_source: 'hr1',
        employment_status: 'ACTIVE',
        department: 'Engineering',
        job_title: 'Senior Developer',
        is_demo_user: true
      },
      {
        email: 'jane.smith@abc.com',
        name: 'Jane Smith',
        platform_source: 'hr2',
        employment_status: 'ACTIVE',
        department: 'Marketing',
        job_title: 'Marketing Manager',
        is_demo_user: true
      },
      {
        email: 'bob.wilson@abc.com',
        name: 'Bob Wilson',
        platform_source: 'zendesk',
        is_demo_user: true
      }
    ]
    
    demo_data.each do |user_data|
      find_or_create_from_platform(
        user_data[:email],
        user_data[:platform_source],
        user_data
      )
    end
  end
end
