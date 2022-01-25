class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.datetime :deleted_at, index: true

      t.string :first_name
      t.string :last_name

      t.string :telephone
      t.string :email

      t.string :gender

      t.date   :birthdate
      t.string :billing_name
      t.string :billing_address
      t.string :billing_identifier

      t.text   :note

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end
    add_reference   :clients, :catalog_client_types, foreign_key: true
    add_reference   :clients, :accounts,     foreign_key: true

    add_foreign_key :clients, :users, column: :user_creator_id
    add_foreign_key :clients, :users, column: :user_modifier_id
  end
end
