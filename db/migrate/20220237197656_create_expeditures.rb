class CreateExpeditures < ActiveRecord::Migration[6.1]
  def change
    create_table :expeditures do |t|
      t.string :description

      t.text    :note

      t.decimal :amount
      t.timestamp :expediture_date

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :expeditures, :expediture_type,           foreign_key: true
    add_reference   :expeditures, :account,                           foreign_key: true
    add_reference   :expeditures, :cash_register,                     foreign_key: true

    add_foreign_key :expeditures, :users, column: :user_creator_id
    add_foreign_key :expeditures, :users, column: :user_modifier_id
  end
end