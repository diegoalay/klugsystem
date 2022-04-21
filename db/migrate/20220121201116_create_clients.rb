class CreateClients < ActiveRecord::Migration[6.1]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :second_name
      t.string :third_name
      t.string :first_surname
      t.string :second_surname
      t.string :married_name

      t.string :telephone
      t.string :mobile_number
      t.string :fax

      t.string :email

      t.string :gender
      t.string :title

      t.date   :birthdate
      t.string :billing_name
      t.string :billing_address
      t.string :billing_identifier
      t.string :billing_email

      t.text   :note

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end
    add_reference   :clients, :client_type, foreign_key: true
    add_reference   :clients, :account,     foreign_key: true

    add_foreign_key :clients, :users, column: :user_creator_id
    add_foreign_key :clients, :users, column: :user_modifier_id
  end
end
