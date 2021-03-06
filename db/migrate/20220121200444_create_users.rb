# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.datetime :deleted_at, index: true

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      # Details
      t.string :title
      t.string :salutation

      t.string :first_name
      t.string :second_name
      t.string :first_surname
      t.string :second_surname
      t.string :telephone
      t.string :address
      t.string :username

      # Users Relations
      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps null: false
    end

    add_index       :users, :email,                unique: true
    add_index       :users, :reset_password_token, unique: true
    add_reference   :users, :account, foreign_key: true

    add_foreign_key :users, :users, column: :user_creator_id
    add_foreign_key :users, :users, column: :user_modifier_id

    add_foreign_key :roles, :users, column: :user_creator_id
    add_foreign_key :roles, :users, column: :user_modifier_id

    add_foreign_key :accounts, :users, column: :user_creator_id
    add_foreign_key :accounts, :users, column: :user_modifier_id
  end
end