class CreateProviders < ActiveRecord::Migration[6.1]
  def change
    create_table :providers do |t|
      t.string :company_name

      t.string :billing_name
      t.string :billing_identifier
      t.string :billing_address
      t.string :billing_postcode
      t.string :billing_department
      t.string :billing_municipality

      t.string :address
      t.string :email
      t.string :telephone
      t.string :mobile_number
      t.string :fax
      t.string :website

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :providers, :account, foreign_key: true

    add_foreign_key :providers, :users, column: :user_creator_id
    add_foreign_key :providers, :users, column: :user_modifier_id
  end
end
