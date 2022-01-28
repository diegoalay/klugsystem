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

ActiveRecord::Schema.define(version: 2022_01_27_197655) do

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

  create_table "branch_office_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "branch_offices_id"
    t.index ["branch_offices_id"], name: "index_branch_office_activities_on_branch_offices_id"
  end

  create_table "branch_offices", force: :cascade do |t|
    t.string "name"
    t.string "telephone"
    t.string "legal_identifier"
    t.string "street_address"
    t.string "street_name"
    t.string "street_number"
    t.string "postcode"
    t.boolean "electronic_billing"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_branch_offices_on_accounts_id"
    t.index ["deleted_at"], name: "index_branch_offices_on_deleted_at"
  end

  create_table "brand_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "brands_id"
    t.index ["brands_id"], name: "index_brand_activities_on_brands_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_brands_on_accounts_id"
    t.index ["deleted_at"], name: "index_brands_on_deleted_at"
  end

  create_table "catalog_client_types", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
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
    t.bigint "user_modifier_id"
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
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
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
    t.bigint "user_modifier_id"
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
    t.string "mobile_number"
    t.string "fax"
    t.string "email"
    t.string "gender"
    t.string "title"
    t.date "birthdate"
    t.string "billing_name"
    t.string "billing_address"
    t.string "billing_identifier"
    t.string "billing_email"
    t.text "note"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_client_types_id"
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_clients_on_accounts_id"
    t.index ["catalog_client_types_id"], name: "index_clients_on_catalog_client_types_id"
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
  end

  create_table "department_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "departments_id"
    t.index ["departments_id"], name: "index_department_activities_on_departments_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_departments_on_accounts_id"
    t.index ["deleted_at"], name: "index_departments_on_deleted_at"
  end

  create_table "event_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "events_id"
    t.index ["events_id"], name: "index_event_activities_on_events_id"
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
    t.bigint "user_modifier_id"
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

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_items_on_accounts_id"
  end

  create_table "product_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "products_id"
    t.index ["products_id"], name: "index_product_activities_on_products_id"
  end

  create_table "product_files", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.decimal "retail_price", default: "0.0"
    t.decimal "wholesale_price", default: "0.0"
    t.decimal "purchase_price", default: "0.0"
    t.decimal "quantity", default: "0.0"
    t.text "note"
    t.string "status"
    t.string "product_type"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.bigint "brands_id"
    t.bigint "branch_offices_id"
    t.bigint "items_id"
    t.bigint "departments_id"
    t.index ["accounts_id"], name: "index_products_on_accounts_id"
    t.index ["branch_offices_id"], name: "index_products_on_branch_offices_id"
    t.index ["brands_id"], name: "index_products_on_brands_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["departments_id"], name: "index_products_on_departments_id"
    t.index ["items_id"], name: "index_products_on_items_id"
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

  create_table "sale_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sales_id"
    t.index ["sales_id"], name: "index_sale_activities_on_sales_id"
  end

  create_table "sale_details", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sales", force: :cascade do |t|
    t.string "uuid"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
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
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "accounts_id"
    t.index ["accounts_id"], name: "index_users_on_accounts_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "branch_office_activities", "branch_offices", column: "branch_offices_id"
  add_foreign_key "branch_office_activities", "users", column: "user_creator_id"
  add_foreign_key "branch_office_activities", "users", column: "user_modifier_id"
  add_foreign_key "branch_offices", "accounts", column: "accounts_id"
  add_foreign_key "branch_offices", "users", column: "user_creator_id"
  add_foreign_key "branch_offices", "users", column: "user_modifier_id"
  add_foreign_key "brand_activities", "brands", column: "brands_id"
  add_foreign_key "brand_activities", "users", column: "user_creator_id"
  add_foreign_key "brand_activities", "users", column: "user_modifier_id"
  add_foreign_key "brands", "accounts", column: "accounts_id"
  add_foreign_key "brands", "users", column: "user_creator_id"
  add_foreign_key "brands", "users", column: "user_modifier_id"
  add_foreign_key "catalog_client_types", "accounts", column: "accounts_id"
  add_foreign_key "catalog_client_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_client_types", "users", column: "user_modifier_id"
  add_foreign_key "catalog_event_types", "accounts", column: "accounts_id"
  add_foreign_key "catalog_event_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_event_types", "users", column: "user_modifier_id"
  add_foreign_key "client_activities", "clients", column: "clients_id"
  add_foreign_key "client_activities", "users", column: "user_creator_id"
  add_foreign_key "client_activities", "users", column: "user_modifier_id"
  add_foreign_key "client_files", "clients", column: "clients_id"
  add_foreign_key "client_files", "users", column: "user_creator_id"
  add_foreign_key "client_files", "users", column: "user_modifier_id"
  add_foreign_key "clients", "accounts", column: "accounts_id"
  add_foreign_key "clients", "catalog_client_types", column: "catalog_client_types_id"
  add_foreign_key "clients", "users", column: "user_creator_id"
  add_foreign_key "clients", "users", column: "user_modifier_id"
  add_foreign_key "department_activities", "departments", column: "departments_id"
  add_foreign_key "department_activities", "users", column: "user_creator_id"
  add_foreign_key "department_activities", "users", column: "user_modifier_id"
  add_foreign_key "departments", "accounts", column: "accounts_id"
  add_foreign_key "departments", "users", column: "user_creator_id"
  add_foreign_key "departments", "users", column: "user_modifier_id"
  add_foreign_key "event_activities", "events", column: "events_id"
  add_foreign_key "event_activities", "users", column: "user_creator_id"
  add_foreign_key "event_activities", "users", column: "user_modifier_id"
  add_foreign_key "events", "accounts", column: "accounts_id"
  add_foreign_key "events", "catalog_event_types", column: "catalog_event_types_id"
  add_foreign_key "events", "users", column: "user_creator_id"
  add_foreign_key "events", "users", column: "user_modifier_id"
  add_foreign_key "items", "accounts", column: "accounts_id"
  add_foreign_key "items", "users", column: "user_creator_id"
  add_foreign_key "items", "users", column: "user_modifier_id"
  add_foreign_key "product_activities", "products", column: "products_id"
  add_foreign_key "product_activities", "users", column: "user_creator_id"
  add_foreign_key "product_activities", "users", column: "user_modifier_id"
  add_foreign_key "products", "accounts", column: "accounts_id"
  add_foreign_key "products", "branch_offices", column: "branch_offices_id"
  add_foreign_key "products", "brands", column: "brands_id"
  add_foreign_key "products", "departments", column: "departments_id"
  add_foreign_key "products", "items", column: "items_id"
  add_foreign_key "products", "users", column: "user_creator_id"
  add_foreign_key "products", "users", column: "user_modifier_id"
  add_foreign_key "sale_activities", "sales", column: "sales_id"
  add_foreign_key "sale_activities", "users", column: "user_creator_id"
  add_foreign_key "sale_activities", "users", column: "user_modifier_id"
  add_foreign_key "user_roles", "roles", column: "roles_id"
  add_foreign_key "user_roles", "users", column: "user_creator_id"
  add_foreign_key "user_roles", "users", column: "user_modifier_id"
  add_foreign_key "user_roles", "users", column: "users_id"
  add_foreign_key "users", "accounts", column: "accounts_id"
  add_foreign_key "users", "users", column: "user_creator_id"
end
