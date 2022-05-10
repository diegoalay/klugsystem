class CreateQuotations < ActiveRecord::Migration[6.1]
  def change
    create_table :quotations do |t|
      t.string :uuid
      t.string :quotation_type
      t.string :client_name
      t.string :client_email
      t.string :client_address
      t.string :client_billing_identifier

      t.decimal :shipping_costs
      t.decimal :subtotal
      t.decimal :total
      t.decimal :discount
      t.decimal :interest
      t.decimal :received_amount
      t.decimal :change

      t.boolean :status, defaullt: :true
      t.datetime :quotation_date

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :quotations, :account,           foreign_key: true
    add_reference   :quotations, :employee,          foreign_key: true
    add_reference   :quotations, :payment_method,    foreign_key: true
    add_reference   :quotations, :branch_office,     foreign_key: true

    add_foreign_key :quotations, :users, column: :user_creator_id
    add_foreign_key :quotations, :users, column: :user_modifier_id

  end
end
