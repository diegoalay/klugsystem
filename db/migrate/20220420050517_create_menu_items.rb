class CreateMenuItems < ActiveRecord::Migration[6.1]
  def change
    create_table :menu_items do |t|
      t.string :key
      t.string :icon
      t.integer :order
      t.jsonb :permissions, default: []

      t.timestamps
    end

    add_reference :menu_items, :menu_item, foreign_key: true
  end
end
