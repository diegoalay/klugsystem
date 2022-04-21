class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.datetime :deleted_at, index: true

      t.text      :description

      t.datetime  :date
      t.datetime  :time_start
      t.datetime  :time_end

      t.string    :title
      t.string    :location
      t.string    :url

      t.boolean   :public

      t.bigint   :user_creator_id
      t.bigint   :user_modifier_id

      t.timestamps
    end

    add_reference   :events, :account,    foreign_key: true
    add_reference   :events, :model,       polymorphic: true
    add_reference   :events, :event_type, foreign_key: true

    add_foreign_key :events, :users, column: :user_creator_id
    add_foreign_key :events, :users, column: :user_modifier_id
  end
end