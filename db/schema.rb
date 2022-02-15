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

ActiveRecord::Schema.define(version: 2022_02_37_198656) do

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
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "branch_office_id"
    t.index ["branch_office_id"], name: "index_branch_office_activities_on_branch_office_id"
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
    t.bigint "account_id"
    t.index ["account_id"], name: "index_branch_offices_on_account_id"
    t.index ["deleted_at"], name: "index_branch_offices_on_deleted_at"
  end

  create_table "brand_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "brand_id"
    t.index ["brand_id"], name: "index_brand_activities_on_brand_id"
  end

  create_table "brands", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_brands_on_account_id"
    t.index ["deleted_at"], name: "index_brands_on_deleted_at"
  end

  create_table "cash_register_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "cash_register_id"
    t.index ["cash_register_id"], name: "index_cash_register_activities_on_cash_register_id"
  end

  create_table "cash_registers", force: :cascade do |t|
    t.date "open_date"
    t.date "close_date"
    t.decimal "initial_value"
    t.decimal "final_value"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "user_id"
    t.index ["account_id"], name: "index_cash_registers_on_account_id"
    t.index ["deleted_at"], name: "index_cash_registers_on_deleted_at"
    t.index ["user_id"], name: "index_cash_registers_on_user_id"
  end

  create_table "catalog_client_type_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_client_type_id"
    t.index ["catalog_client_type_id"], name: "index_catalog_client_type_activities_on_catalog_client_type_id"
  end

  create_table "catalog_client_types", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.text "note"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_catalog_client_types_on_account_id"
    t.index ["deleted_at"], name: "index_catalog_client_types_on_deleted_at"
  end

  create_table "catalog_event_type_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_event_type_id"
    t.index ["catalog_event_type_id"], name: "index_catalog_event_type_activities_on_catalog_event_type_id"
  end

  create_table "catalog_event_types", force: :cascade do |t|
    t.datetime "deleted_at"
    t.string "name"
    t.text "note"
    t.string "model_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_catalog_event_types_on_account_id"
    t.index ["deleted_at"], name: "index_catalog_event_types_on_deleted_at"
    t.index ["model_type"], name: "index_catalog_event_types_on_model_type"
  end

  create_table "catalog_expediture_type_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_expediture_type_id"
    t.index ["catalog_expediture_type_id"], name: "catalog_expediture_type_activities_catalog_expediture_types"
  end

  create_table "catalog_expediture_types", force: :cascade do |t|
    t.string "name"
    t.text "note"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_catalog_expediture_types_on_account_id"
    t.index ["deleted_at"], name: "index_catalog_expediture_types_on_deleted_at"
  end

  create_table "client_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.index ["client_id"], name: "index_client_activities_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "third_name"
    t.string "first_surname"
    t.string "second_surname"
    t.string "married_name"
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
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_client_type_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_clients_on_account_id"
    t.index ["catalog_client_type_id"], name: "index_clients_on_catalog_client_type_id"
    t.index ["deleted_at"], name: "index_clients_on_deleted_at"
  end

  create_table "department_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "department_id"
    t.index ["department_id"], name: "index_department_activities_on_department_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "department_id"
    t.bigint "account_id"
    t.index ["account_id"], name: "index_departments_on_account_id"
    t.index ["deleted_at"], name: "index_departments_on_deleted_at"
    t.index ["department_id"], name: "index_departments_on_department_id"
  end

  create_table "employee_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "employee_id"
    t.index ["employee_id"], name: "index_employee_activities_on_employee_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "first_name"
    t.string "second_name"
    t.string "third_name"
    t.string "first_surname"
    t.string "second_surname"
    t.string "married_name"
    t.date "birthdate"
    t.string "identity_document_number"
    t.string "passport_number"
    t.string "marital_status"
    t.string "gender"
    t.string "blood_type"
    t.json "biography"
    t.json "family_background"
    t.json "health_details"
    t.date "contract_date"
    t.decimal "salary_base"
    t.decimal "salary_administrative"
    t.decimal "bonuses"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "user_id"
    t.index ["account_id"], name: "index_employees_on_account_id"
    t.index ["deleted_at"], name: "index_employees_on_deleted_at"
    t.index ["user_id"], name: "index_employees_on_user_id"
  end

  create_table "event_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "event_id"
    t.index ["event_id"], name: "index_event_activities_on_event_id"
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
    t.bigint "account_id"
    t.string "model_type"
    t.bigint "model_id"
    t.bigint "catalog_event_type_id"
    t.index ["account_id"], name: "index_events_on_account_id"
    t.index ["catalog_event_type_id"], name: "index_events_on_catalog_event_type_id"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
    t.index ["model_type", "model_id"], name: "index_events_on_model"
  end

  create_table "expediture_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "expediture_id"
    t.index ["expediture_id"], name: "index_expediture_activities_on_expediture_id"
  end

  create_table "expeditures", force: :cascade do |t|
    t.string "description"
    t.text "note"
    t.decimal "amount"
    t.date "expediture_date"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "catalog_expediture_type_id"
    t.bigint "account_id"
    t.bigint "cash_register_id"
    t.index ["account_id"], name: "index_expeditures_on_account_id"
    t.index ["cash_register_id"], name: "index_expeditures_on_cash_register_id"
    t.index ["catalog_expediture_type_id"], name: "index_expeditures_on_catalog_expediture_type_id"
    t.index ["deleted_at"], name: "index_expeditures_on_deleted_at"
  end

  create_table "payment_method_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "payment_method_id"
    t.index ["payment_method_id"], name: "index_payment_method_activities_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name"
    t.decimal "interest_percentage"
    t.decimal "interest_value"
    t.decimal "discount_percentage"
    t.decimal "discount_value"
    t.boolean "status"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_payment_methods_on_account_id"
    t.index ["deleted_at"], name: "index_payment_methods_on_deleted_at"
  end

  create_table "product_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "product_id"
    t.index ["product_id"], name: "index_product_activities_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.string "name"
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
    t.bigint "account_id"
    t.bigint "brand_id"
    t.bigint "branch_office_id"
    t.bigint "department_id"
    t.index ["account_id"], name: "index_products_on_account_id"
    t.index ["branch_office_id"], name: "index_products_on_branch_office_id"
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
    t.index ["department_id"], name: "index_products_on_department_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.string "default_path"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_roles_on_account_id"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "sale_activities", force: :cascade do |t|
    t.string "description"
    t.string "field_name"
    t.string "value_from"
    t.string "value_to"
    t.string "category"
    t.string "field_type"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at, index: true"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "sale_id"
    t.index ["sale_id"], name: "index_sale_activities_on_sale_id"
  end

  create_table "sale_details", force: :cascade do |t|
    t.text "name"
    t.decimal "total"
    t.decimal "price"
    t.decimal "subtotal"
    t.decimal "quantity"
    t.decimal "discount_value"
    t.decimal "discount_percentage"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.bigint "product_id"
    t.bigint "sale_id"
    t.index ["account_id"], name: "index_sale_details_on_account_id"
    t.index ["deleted_at"], name: "index_sale_details_on_deleted_at"
    t.index ["product_id"], name: "index_sale_details_on_product_id"
    t.index ["sale_id"], name: "index_sale_details_on_sale_id"
  end

  create_table "sales", force: :cascade do |t|
    t.string "uuid"
    t.string "sale_type"
    t.decimal "shipping_costs"
    t.decimal "subtotal"
    t.decimal "total"
    t.decimal "discount"
    t.decimal "interest"
    t.decimal "received_amount"
    t.decimal "change"
    t.date "sale_date"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "client_id"
    t.bigint "account_id"
    t.bigint "employee_id"
    t.bigint "cash_register_id"
    t.bigint "payment_method_id"
    t.index ["account_id"], name: "index_sales_on_account_id"
    t.index ["cash_register_id"], name: "index_sales_on_cash_register_id"
    t.index ["client_id"], name: "index_sales_on_client_id"
    t.index ["deleted_at"], name: "index_sales_on_deleted_at"
    t.index ["employee_id"], name: "index_sales_on_employee_id"
    t.index ["payment_method_id"], name: "index_sales_on_payment_method_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["deleted_at"], name: "index_user_roles_on_deleted_at"
    t.index ["role_id"], name: "index_user_roles_on_role_id"
    t.index ["user_id"], name: "index_user_roles_on_user_id"
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
    t.string "second_name"
    t.string "first_surname"
    t.string "second_surname"
    t.string "telephone"
    t.string "address"
    t.bigint "user_creator_id"
    t.bigint "user_modifier_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "branch_office_activities", "branch_offices"
  add_foreign_key "branch_office_activities", "users", column: "user_creator_id"
  add_foreign_key "branch_office_activities", "users", column: "user_modifier_id"
  add_foreign_key "branch_offices", "accounts"
  add_foreign_key "branch_offices", "users", column: "user_creator_id"
  add_foreign_key "branch_offices", "users", column: "user_modifier_id"
  add_foreign_key "brand_activities", "brands"
  add_foreign_key "brand_activities", "users", column: "user_creator_id"
  add_foreign_key "brand_activities", "users", column: "user_modifier_id"
  add_foreign_key "brands", "accounts"
  add_foreign_key "brands", "users", column: "user_creator_id"
  add_foreign_key "brands", "users", column: "user_modifier_id"
  add_foreign_key "cash_register_activities", "cash_registers"
  add_foreign_key "cash_register_activities", "users", column: "user_creator_id"
  add_foreign_key "cash_register_activities", "users", column: "user_modifier_id"
  add_foreign_key "cash_registers", "accounts"
  add_foreign_key "cash_registers", "users"
  add_foreign_key "cash_registers", "users", column: "user_creator_id"
  add_foreign_key "cash_registers", "users", column: "user_modifier_id"
  add_foreign_key "catalog_client_type_activities", "catalog_client_types"
  add_foreign_key "catalog_client_type_activities", "users", column: "user_creator_id"
  add_foreign_key "catalog_client_type_activities", "users", column: "user_modifier_id"
  add_foreign_key "catalog_client_types", "accounts"
  add_foreign_key "catalog_client_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_client_types", "users", column: "user_modifier_id"
  add_foreign_key "catalog_event_type_activities", "catalog_event_types"
  add_foreign_key "catalog_event_type_activities", "users", column: "user_creator_id"
  add_foreign_key "catalog_event_type_activities", "users", column: "user_modifier_id"
  add_foreign_key "catalog_event_types", "accounts"
  add_foreign_key "catalog_event_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_event_types", "users", column: "user_modifier_id"
  add_foreign_key "catalog_expediture_type_activities", "catalog_expediture_types"
  add_foreign_key "catalog_expediture_type_activities", "users", column: "user_creator_id"
  add_foreign_key "catalog_expediture_type_activities", "users", column: "user_modifier_id"
  add_foreign_key "catalog_expediture_types", "accounts"
  add_foreign_key "catalog_expediture_types", "users", column: "user_creator_id"
  add_foreign_key "catalog_expediture_types", "users", column: "user_modifier_id"
  add_foreign_key "client_activities", "clients"
  add_foreign_key "client_activities", "users", column: "user_creator_id"
  add_foreign_key "client_activities", "users", column: "user_modifier_id"
  add_foreign_key "clients", "accounts"
  add_foreign_key "clients", "catalog_client_types"
  add_foreign_key "clients", "users", column: "user_creator_id"
  add_foreign_key "clients", "users", column: "user_modifier_id"
  add_foreign_key "department_activities", "departments"
  add_foreign_key "department_activities", "users", column: "user_creator_id"
  add_foreign_key "department_activities", "users", column: "user_modifier_id"
  add_foreign_key "departments", "accounts"
  add_foreign_key "departments", "departments"
  add_foreign_key "departments", "users", column: "user_creator_id"
  add_foreign_key "departments", "users", column: "user_modifier_id"
  add_foreign_key "employee_activities", "employees"
  add_foreign_key "employee_activities", "users", column: "user_creator_id"
  add_foreign_key "employee_activities", "users", column: "user_modifier_id"
  add_foreign_key "employees", "accounts"
  add_foreign_key "employees", "users"
  add_foreign_key "employees", "users", column: "user_creator_id"
  add_foreign_key "employees", "users", column: "user_modifier_id"
  add_foreign_key "event_activities", "events"
  add_foreign_key "event_activities", "users", column: "user_creator_id"
  add_foreign_key "event_activities", "users", column: "user_modifier_id"
  add_foreign_key "events", "accounts"
  add_foreign_key "events", "catalog_event_types"
  add_foreign_key "events", "users", column: "user_creator_id"
  add_foreign_key "events", "users", column: "user_modifier_id"
  add_foreign_key "expediture_activities", "expeditures"
  add_foreign_key "expediture_activities", "users", column: "user_creator_id"
  add_foreign_key "expediture_activities", "users", column: "user_modifier_id"
  add_foreign_key "expeditures", "accounts"
  add_foreign_key "expeditures", "cash_registers"
  add_foreign_key "expeditures", "catalog_expediture_types"
  add_foreign_key "expeditures", "users", column: "user_creator_id"
  add_foreign_key "expeditures", "users", column: "user_modifier_id"
  add_foreign_key "payment_method_activities", "payment_methods"
  add_foreign_key "payment_method_activities", "users", column: "user_creator_id"
  add_foreign_key "payment_method_activities", "users", column: "user_modifier_id"
  add_foreign_key "payment_methods", "accounts"
  add_foreign_key "payment_methods", "users", column: "user_creator_id"
  add_foreign_key "payment_methods", "users", column: "user_modifier_id"
  add_foreign_key "product_activities", "products"
  add_foreign_key "product_activities", "users", column: "user_creator_id"
  add_foreign_key "product_activities", "users", column: "user_modifier_id"
  add_foreign_key "products", "accounts"
  add_foreign_key "products", "branch_offices"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "departments"
  add_foreign_key "products", "users", column: "user_creator_id"
  add_foreign_key "products", "users", column: "user_modifier_id"
  add_foreign_key "roles", "accounts"
  add_foreign_key "sale_activities", "sales"
  add_foreign_key "sale_activities", "users", column: "user_creator_id"
  add_foreign_key "sale_activities", "users", column: "user_modifier_id"
  add_foreign_key "sale_details", "accounts"
  add_foreign_key "sale_details", "products"
  add_foreign_key "sale_details", "sales"
  add_foreign_key "sale_details", "users", column: "user_creator_id"
  add_foreign_key "sale_details", "users", column: "user_modifier_id"
  add_foreign_key "sales", "accounts"
  add_foreign_key "sales", "cash_registers"
  add_foreign_key "sales", "clients"
  add_foreign_key "sales", "employees"
  add_foreign_key "sales", "payment_methods"
  add_foreign_key "sales", "users", column: "user_creator_id"
  add_foreign_key "sales", "users", column: "user_modifier_id"
  add_foreign_key "user_roles", "roles"
  add_foreign_key "user_roles", "users"
  add_foreign_key "user_roles", "users", column: "user_creator_id"
  add_foreign_key "user_roles", "users", column: "user_modifier_id"
  add_foreign_key "users", "accounts"
  add_foreign_key "users", "users", column: "user_creator_id"
end
