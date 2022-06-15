class CreateBillTemplates < ActiveRecord::Migration[6.1]
  def change
    create_table :bill_templates do |t|
      t.text    :name
      t.string :measurement_unit
      t.string :product_type
      t.string :title

      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.datetime :deleted_at, index: true

      t.timestamps
    end

    add_reference   :bill_templates,  :account,  foreign_key: true

    add_foreign_key :bill_templates, :users, column: :user_creator_id
    add_foreign_key :bill_templates, :users, column: :user_modifier_id
  end
end
