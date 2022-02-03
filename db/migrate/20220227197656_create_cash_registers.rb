class CreateCashRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :cash_registers do |t|
      t.date    :open_date
      t.date    :close_date

      t.decimal :initial_value
      t.decimal :final_value

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :cash_registers, :accounts,     foreign_key: true
    add_reference   :cash_registers, :users,        foreign_key: true

    add_foreign_key :cash_registers, :users, column: :user_creator_id
    add_foreign_key :cash_registers, :users, column: :user_modifier_id
  end
end
