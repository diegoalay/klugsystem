class CreateSaleDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :sale_details do |t|
      t.text    :name

      t.decimal :total
      t.decimal :price
      t.decimal :subtotal
      t.decimal :quantity
      t.decimal :discount_value
      t.decimal :discount_percentage
      t.string :measurement_unit

      t.boolean :status, defaullt: :true

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :sale_details,  :account,  foreign_key: true
    add_reference   :sale_details,  :product,  foreign_key: true
    add_reference   :sale_details,  :sale,     foreign_key: true

    add_foreign_key :sale_details, :users, column: :user_creator_id
    add_foreign_key :sale_details, :users, column: :user_modifier_id
  end
end
