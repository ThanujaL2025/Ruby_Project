class CreateDataSyncLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :data_sync_logs do |t|
      t.references :integration, null: false, foreign_key: true  # Reference to integration
      t.string :sync_type, null: false                # Type of sync (users, tickets, employees)
      t.string :status, null: false                   # Sync status (success, failed, partial)
      t.integer :records_processed                    # Number of records processed
      t.integer :records_created                      # Number of new records created
      t.integer :records_updated                      # Number of records updated
      t.integer :records_failed                       # Number of records that failed
      t.jsonb :sync_metadata                          # Additional sync details
      t.text :error_message                           # Error message if failed
      t.datetime :started_at                          # Sync start time
      t.datetime :completed_at                        # Sync completion time
      t.integer :duration_seconds                     # Sync duration in seconds
      
      t.timestamps
    end
    
    add_index :data_sync_logs, :sync_type
    add_index :data_sync_logs, :status
    add_index :data_sync_logs, :started_at
    add_index :data_sync_logs, :completed_at
  end
end
