class Integration < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :platform_type, presence: true
  validates :unified_connection_id, presence: true, uniqueness: true
  
  # Enums
  enum :status, { active: 'active', inactive: 'inactive', error: 'error', connecting: 'connecting' }
  
  # Associations
  has_many :data_sync_logs, dependent: :destroy
  has_many :platform_users, dependent: :destroy
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :demo_data, -> { where(is_demo_data: true) }
  scope :by_platform_type, ->(type) { where(platform_type: type) }
  
  # Callbacks
  before_save :update_last_sync_at, if: :status_changed_to_active?
  
  # Platform types
  PLATFORM_TYPES = %w[ticketing hris crm messaging passthrough].freeze
  
  # Methods
  def healthy?
    status == 'active' && last_error_at.nil? || last_error_at < 1.hour.ago
  end
  
  def needs_sync?
    last_sync_at.nil? || last_sync_at < 1.hour.ago
  end
  
  def sync_status
    if healthy? && !needs_sync?
      'healthy'
    elsif healthy? && needs_sync?
      'needs_sync'
    elsif status == 'error'
      'error'
    else
      'unknown'
    end
  end
  
  def platform_icon
    case platform_type
    when 'ticketing'
      '🎫'
    when 'hris'
      '👥'
    when 'crm'
      '👤'
    when 'messaging'
      '💬'
    when 'passthrough'
      '🔗'
    else
      '📱'
    end
  end
  
  def demo_data?
    is_demo_data
  end
  
  def can_sync?
    active? && unified_connection_id.present?
  end
  
  def mark_sync_success(sync_type, metadata = {})
    update!(
      last_sync_at: Time.current,
      last_error_at: nil,
      last_error_message: nil
    )
    
    data_sync_logs.create!(
      sync_type: sync_type,
      status: 'success',
      records_processed: metadata[:processed] || 0,
      records_created: metadata[:created] || 0,
      records_updated: metadata[:updated] || 0,
      sync_metadata: metadata,
      started_at: metadata[:started_at] || Time.current,
      completed_at: Time.current,
      duration_seconds: metadata[:duration] || 0
    )
  end
  
  def mark_sync_error(sync_type, error_message, metadata = {})
    update!(
      last_error_at: Time.current,
      last_error_message: error_message
    )
    
    data_sync_logs.create!(
      sync_type: sync_type,
      status: 'failed',
      error_message: error_message,
      sync_metadata: metadata,
      started_at: metadata[:started_at] || Time.current,
      completed_at: Time.current,
      duration_seconds: metadata[:duration] || 0
    )
  end
  
  private
  
  def status_changed_to_active?
    status_changed? && status == 'active'
  end
  
  def update_last_sync_at
    self.last_sync_at = Time.current
  end
end
