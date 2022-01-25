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

ActiveRecord::Schema.define(version: 102001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "direction"
    t.string "telephone"
    t.string "billing_identifier"
    t.string "billing_name"
    t.string "billing_direction"
    t.text "description"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "catalog_client_types", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_catalog_client_types_on_accounts_id"
    t.index ["deleted_at"], name: "index_catalog_client_types_on_deleted_at"
  end

  create_table "catalog_event_types", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.string "model_type"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_catalog_event_types_on_accounts_id"
    t.index ["deleted_at"], name: "index_catalog_event_types_on_deleted_at"
    t.index ["model_type"], name: "index_catalog_event_types_on_model_type"
  end

  create_table "client_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "clients_id"
    t.index ["clients_id"], name: "index_client_activities_on_clients_id"
  end

  create_table "client_files", force: :cascade do |t|
    t.string "name"
    t.string "attachment"
    t.string "attachment_s3"
    t.string "attachment_public"
    t.string "file_extension"
    t.string "file_type"
    t.bigint "user_creator_id"
    t.decimal "size_mb"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "clients_id"
    t.index ["clients_id"], name: "index_client_files_on_clients_id"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "first_name"
    t.string "last_name"
    t.string "telephone"
    t.string "email"
    t.string "gender"
    t.date "birthdate"
    t.string "billing_name"
    t.string "billing_address"
    t.string "billing_identifier"
    t.text "note"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_client_types_id"
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_clients_on_accounts_id"
    t.index ["catalog_client_types_id"], name: "index_clients_on_catalog_client_types_id"
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "deleted_at"
    t.text "description"
    t.datetime "event_date"
    t.datetime "time_start"
    t.datetime "time_end"
    t.string "title"
    t.string "location"
    t.string "url"
    t.boolean "public"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.string "model_type"
    t.bigint "model_id"
    t.bigint "catalog_event_types_id"
    t.index ["accounts_id"], name: "index_events_on_accounts_id"
    t.index ["catalog_event_types_id"], name: "index_events_on_catalog_event_types_id"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["model_type", "model_id"], name: "index_events_on_model"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.string "default_path"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "users_id"
    t.bigint "roles_id"
    t.index ["deleted_at"], name: "index_user_roles_on_deleted_at"
    t.index ["roles_id"], name: "index_user_roles_on_roles_id"
    t.index ["users_id"], name: "index_user_roles_on_users_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "title"
    t.string "salutation"
    t.string "first_name"
    t.string "last_name"
    t.string "telephone"
    t.string "address"
    t.bigint "user_creator_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "catalog_client_types", "accounts", column: "accounts_id"
  add_foreign_key "catalog_client_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_event_types", "accounts", column: "accounts_id"
  add_foreign_key "catalog_event_types", "users", column: "user_creator_id"
  add_foreign_key "client_activities", "clients", column: "clients_id"
  add_foreign_key "client_activities", "users", column: "user_creator_id"
  add_foreign_key "client_files", "clients", column: "clients_id"
  add_foreign_key "client_files", "users", column: "user_creator_id"
  add_foreign_key "clients", "accounts", column: "accounts_id"
  add_foreign_key "clients", "catalog_client_types", column: "catalog_client_types_id"
  add_foreign_key "clients", "users", column: "user_creator_id"
  add_foreign_key "events", "accounts", column: "accounts_id"
  add_foreign_key "events", "catalog_event_types", column: "catalog_event_types_id"
  add_foreign_key "events", "users", column: "user_creator_id"
  add_foreign_key "user_roles", "roles", column: "roles_id"
  add_foreign_key "user_roles", "users", column: "user_creator_id"
  add_foreign_key "user_roles", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "users", column: "user_creator_id"
end
