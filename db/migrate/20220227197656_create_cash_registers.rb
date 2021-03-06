class CreateCashRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :cash_registers do |t|
      t.datetime    :open_date
      t.datetime    :close_date

      t.decimal :initial_value
      t.decimal :final_value

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :cash_registers, :account,     foreign_key: true
    add_reference   :cash_registers, :user,        foreign_key: true

    add_foreign_key :cash_registers, :users, column: :user_creator_id
    add_foreign_key :cash_registers, :users, column: :user_modifier_id
  end
end
