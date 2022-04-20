class CreateBranchOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :branch_offices do |t|
      # General Information
      t.string :name
      t.string :telephone
      t.string :street_address
      t.string :street_name
      t.string :street_number
      t.string :postcode

      # Billing Information
      t.string :billing_identifier
      t.string :billing_direction
      t.string :billing_municipality
      t.string :billing_postcode
      t.string :billing_department

      t.boolean :electronic_billing

      t.datetime :deleted_at, index: true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :branch_offices, :account,     foreign_key: true

    add_foreign_key :branch_offices, :users, column: :user_creator_id
    add_foreign_key :branch_offices, :users, column: :user_modifier_id

    add_reference   :users, :branch_office,     foreign_key: true
  end
end
