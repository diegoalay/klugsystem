class CreateAccountBillingFields < ActiveRecord::Migration[6.1]
  def change
    create_table :account_billing_fields do |t|
      t.string :title
      t.string :label
      t.string :type
      t.string :value
      t.string :color
      t.decimal :position_x
      t.decimal :position_y
      t.boolean :disabled

      t.jsonb  :settings

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :account_billing_fields,  :account,  foreign_key: true

    add_foreign_key :account_billing_fields, :users, column: :user_creator_id
    add_foreign_key :account_billing_fields, :users, column: :user_modifier_id
  end
end
