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

      t.boolean :status, defaullt: :true
      t.datetime :sale_date

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :sales, :client, foreign_key: true
    add_reference   :sales, :account, foreign_key: true
    add_reference   :sales, :employee, foreign_key: true
    add_reference   :sales, :cash_register, foreign_key: true
    add_reference   :sales, :payment_method, foreign_key: true
    add_reference   :sales, :branch_office, foreign_key: true

    add_foreign_key :sales, :users, column: :user_creator_id
    add_foreign_key :sales, :users, column: :user_modifier_id
  end
end
