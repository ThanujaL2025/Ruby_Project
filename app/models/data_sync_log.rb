class DataSyncLog < ApplicationRecord
  # Validations
  validates :integration, presence: true
  validates :sync_type, presence: true
  validates :status, presence: true
  
  # Associations
  belongs_to :integration
  
  # Scopes
  scope :successful, -> { where(status: 'success') }
  scope :failed, -> { where(status: 'failed') }
  scope :partial, -> { where(status: 'partial') }
  scope :by_sync_type, ->(type) { where(sync_type: type) }
  scope :recent, -> { where('created_at > ?', 24.hours.ago) }
  scope :by_integration, ->(integration_id) { where(integration_id: integration_id) }
  
  # Enums
  enum :status, { success: 'success', failed: 'failed', partial: 'partial' }
  
  # Sync types
  SYNC_TYPES = %w[users tickets employees companies contacts analytics].freeze
  
  # Methods
  def duration_minutes
    (duration_seconds / 60.0).round(2)
  end
  
  def success_rate
    return 0 if records_processed.zero?
    ((records_created + records_updated).to_f / records_processed * 100).round(2)
  end
  
  def is_successful?
    status == 'success'
  end
  
  def is_failed?
    status == 'failed'
  end
  
  def is_partial?
    status == 'partial'
  end
  
  def has_errors?
    records_failed.to_i > 0
  end
  
  def sync_summary
    {
      type: sync_type,
      status: status,
      processed: records_processed,
      created: records_created,
      updated: records_updated,
      failed: records_failed,
      success_rate: success_rate,
      duration: duration_minutes
    }
  end
  
  def mark_completed(metadata = {})
    update!(
      completed_at: Time.current,
      duration_seconds: Time.current - started_at.to_i,
      sync_metadata: sync_metadata.merge(metadata)
    )
  end
  
  def add_error(error_message)
    update!(
      error_message: error_message,
      status: 'failed',
      completed_at: Time.current,
      duration_seconds: Time.current - started_at.to_i
    )
  end
  
  # Class methods
  def self.create_sync_start(integration, sync_type)
    create!(
      integration: integration,
      sync_type: sync_type,
      status: 'pending',
      started_at: Time.current
    )
  end
  
  def self.successful_syncs_count
    successful.count
  end
  
  def self.failed_syncs_count
    failed.count
  end
  
  def self.average_duration
    successful.average(:duration_seconds)&.round(2) || 0
  end
  
  def self.total_records_processed
    sum(:records_processed)
  end
  
  def self.total_records_created
    sum(:records_created)
  end
  
  def self.total_records_updated
    sum(:records_updated)
  end
  
  def self.total_records_failed
    sum(:records_failed)
  end
  
  def self.overall_success_rate
    total_processed = total_records_processed
    return 0 if total_processed.zero?
    
    total_successful = total_records_created + total_records_updated
    (total_successful.to_f / total_processed * 100).round(2)
  end
  
  def self.sync_performance_summary
    {
      total_syncs: count,
      successful_syncs: successful_syncs_count,
      failed_syncs: failed_syncs_count,
      success_rate: (successful_syncs_count.to_f / count * 100).round(2),
      average_duration: average_duration,
      total_records_processed: total_records_processed,
      total_records_created: total_records_created,
      total_records_updated: total_records_updated,
      total_records_failed: total_records_failed,
      overall_success_rate: overall_success_rate
    }
  end
end
