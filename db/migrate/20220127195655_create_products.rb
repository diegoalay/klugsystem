class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      # general information
      t.string  :sku
      t.string  :name

      # price information
      t.decimal :retail_price,   default: 0
      t.decimal :wholesale_price, default: 0
      t.decimal :purchase_price, default: 0
      t.decimal :quantity, default: 0

      t.text :note

      t.string :status
      t.string :product_type #[Goods/Services]
      t.datetime :deleted_at, index:true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :products, :accounts,           foreign_key: true
    add_reference   :products, :brands,             foreign_key: true
    add_reference   :products, :branch_offices,     foreign_key: true
    add_reference   :products, :items,              foreign_key: true
    add_reference   :products, :departments,        foreign_key: true

    add_foreign_key :products, :users, column: :user_creator_id
    add_foreign_key :products, :users, column: :user_modifier_id
  end
end
