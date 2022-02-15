class CreateBranchOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :branch_offices do |t|
      t.string :name
      t.string :telephone
      t.string :legal_identifier

      t.string :street_address
      t.string :street_name
      t.string :street_number
      t.string :postcode

      t.boolean :electronic_billing

      t.datetime :deleted_at, index: true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :branch_offices, :account,     foreign_key: true

    add_foreign_key :branch_offices, :users, column: :user_creator_id
    add_foreign_key :branch_offices, :users, column: :user_modifier_id
  end
end
