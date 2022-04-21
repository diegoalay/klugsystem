class CreateProductTransactionTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :product_transaction_types do |t|
      t.string :name
      t.string :code # internal code

      t.text :note

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :product_transaction_types, :account,                           foreign_key: true, index: { name: "product_transaction_types_accounts" }

    add_foreign_key :product_transaction_types, :users, column: :user_creator_id
    add_foreign_key :product_transaction_types, :users, column: :user_modifier_id
  end
end
