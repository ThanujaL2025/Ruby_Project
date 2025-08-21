# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_12_01_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "data_sync_logs", force: :cascade do |t|
    t.bigint "integration_id", null: false
    t.string "sync_type", null: false
    t.string "status", null: false
    t.integer "records_processed"
    t.integer "records_created"
    t.integer "records_updated"
    t.integer "records_failed"
    t.jsonb "sync_metadata"
    t.text "error_message"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "duration_seconds"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed_at"], name: "index_data_sync_logs_on_completed_at"
    t.index ["integration_id"], name: "index_data_sync_logs_on_integration_id"
    t.index ["started_at"], name: "index_data_sync_logs_on_started_at"
    t.index ["status"], name: "index_data_sync_logs_on_status"
    t.index ["sync_type"], name: "index_data_sync_logs_on_sync_type"
  end

  create_table "integrations", force: :cascade do |t|
    t.string "name", null: false
    t.string "platform_type", null: false
    t.string "unified_connection_id", null: false
    t.string "status", default: "active"
    t.jsonb "connection_metadata"
    t.jsonb "api_endpoints"
    t.datetime "last_sync_at"
    t.datetime "last_error_at"
    t.text "last_error_message"
    t.boolean "is_demo_data", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_demo_data"], name: "index_integrations_on_is_demo_data"
    t.index ["platform_type"], name: "index_integrations_on_platform_type"
    t.index ["status"], name: "index_integrations_on_status"
    t.index ["unified_connection_id"], name: "index_integrations_on_unified_connection_id", unique: true
  end

  create_table "platform_users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "phone"
    t.string "platform_source"
    t.string "unified_user_id"
    t.jsonb "platform_data"
    t.jsonb "unified_profile"
    t.string "employment_status"
    t.string "department"
    t.string "job_title"
    t.boolean "is_demo_user", default: false
    t.datetime "last_seen_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "platform_source"], name: "index_platform_users_on_email_and_platform_source", unique: true
    t.index ["email"], name: "index_platform_users_on_email"
    t.index ["is_demo_user"], name: "index_platform_users_on_is_demo_user"
    t.index ["platform_source"], name: "index_platform_users_on_platform_source"
    t.index ["unified_user_id"], name: "index_platform_users_on_unified_user_id"
  end

  add_foreign_key "data_sync_logs", "integrations"
end
