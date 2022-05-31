class CreateProviderContacts < ActiveRecord::Migration[6.1]
  def change
    create_table :provider_contacts do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :telephone
      t.string :mobile_number
      t.string :description
      t.string :gender
      t.string :title

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :provider_contacts, :account, foreign_key: true

    add_foreign_key :provider_contacts, :users, column: :user_creator_id
    add_foreign_key :provider_contacts, :users, column: :user_modifier_id
  end
end
