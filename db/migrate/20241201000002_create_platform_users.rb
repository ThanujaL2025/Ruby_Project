class CreatePlatformUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :platform_users do |t|
      t.string :email, null: false                    # User's email (primary identifier)
      t.string :name                                   # User's full name
      t.string :phone                                  # User's phone number
      t.string :platform_source                        # Source platform (zendesk, hr1, hr2, hr3, youtube)
      t.string :unified_user_id                        # Unified.to user ID if available
      t.jsonb :platform_data                           # Raw data from the platform
      t.jsonb :unified_profile                         # Unified profile data
      t.string :employment_status                      # Employment status (if HR data)
      t.string :department                             # Department (if HR data)
      t.string :job_title                             # Job title (if HR data)
      t.boolean :is_demo_user, default: false          # Flag for demo users
      t.datetime :last_seen_at                         # Last activity timestamp
      
      t.timestamps
    end
    
    add_index :platform_users, :email
    add_index :platform_users, :platform_source
    add_index :platform_users, :unified_user_id
    add_index :platform_users, :is_demo_user
    add_index :platform_users, [:email, :platform_source], unique: true
  end
end
