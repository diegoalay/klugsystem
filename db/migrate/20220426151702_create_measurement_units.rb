class CreateMeasurementUnits < ActiveRecord::Migration[6.1]
  def change
    create_table :measurement_units do |t|
      t.string :name

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :measurement_units, :account, foreign_key: true
    add_reference   :products, :measurement_unit, foreign_key: true

    add_foreign_key :measurement_units, :users, column: :user_creator_id
    add_foreign_key :measurement_units, :users, column: :user_modifier_id
  end
end
