class CreateSales < ActiveRecord::Migration[6.1]
  def change
    create_table :sales do |t|
      t.string :uuid
      t.string :sale_type

      t.decimal :shipping_costs
      t.decimal :subtotal
      t.decimal :total
      t.decimal :discount
      t.decimal :interest
      t.decimal :received_amount
      t.decimal :change

      t.date :sale_date

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :sales, :clients,            foreign_key: true
    add_reference   :sales, :accounts,           foreign_key: true
    add_reference   :sales, :employees,          foreign_key: true
    add_reference   :sales, :cash_registers,     foreign_key: true
    add_reference   :sales, :payment_methods,     foreign_key: true

    add_foreign_key :sales, :users, column: :user_creator_id
    add_foreign_key :sales, :users, column: :user_modifier_id
  end
end
