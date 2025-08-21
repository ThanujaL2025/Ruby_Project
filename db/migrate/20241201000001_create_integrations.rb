class CreateIntegrations < ActiveRecord::Migration[7.0]
  def change
    create_table :integrations do |t|
      t.string :name, null: false                    # Integration name (e.g., "Zendesk", "HR1", "HR2")
      t.string :platform_type, null: false           # Platform type (e.g., "ticketing", "hris", "crm")
      t.string :unified_connection_id, null: false   # Unified.to connection ID
      t.string :status, default: "active"            # Connection status (active, inactive, error)
      t.jsonb :connection_metadata                   # Additional connection details
      t.jsonb :api_endpoints                         # Available API endpoints
      t.datetime :last_sync_at                       # Last successful data sync
      t.datetime :last_error_at                      # Last error occurrence
      t.text :last_error_message                     # Last error details
      t.boolean :is_demo_data, default: false        # Flag for demo/presentation data
      
      t.timestamps
    end
    
    add_index :integrations, :unified_connection_id, unique: true
    add_index :integrations, :platform_type
    add_index :integrations, :status
    add_index :integrations, :is_demo_data
  end
end
