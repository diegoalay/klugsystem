class CreatePaymentMethods < ActiveRecord::Migration[6.1]
  def change
    create_table :payment_methods do |t|
      t.string :name

      t.decimal :interest_percentage
      t.decimal :interest_value

      t.boolean :status

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end

    add_reference   :payment_methods, :accounts,      foreign_key: true

    add_foreign_key :payment_methods, :users, column: :user_creator_id
    add_foreign_key :payment_methods, :users, column: :user_modifier_id
  end
end
