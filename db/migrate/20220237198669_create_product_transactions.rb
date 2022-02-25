class CreateProductTransactions < ActiveRecord::Migration[6.1]
  def change
    create_table :product_transactions do |t|
      t.text   :description
      t.string :category

      t.float  :quantity

      t.bigint   :user_creator_id

      t.timestamps
    end

    add_reference   :product_transactions, :catalog_product_transaction_type, foreign_key: true, index: { name: "catalog_product_transaction_types_product_transactions" }
    add_reference   :product_transactions, :model,   polymorphic: true
    add_reference   :product_transactions, :product, foreign_key: true

    add_foreign_key :product_transactions, :users,   column: :user_creator_id
  end
end