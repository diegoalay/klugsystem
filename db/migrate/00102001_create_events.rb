class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.datetime :deleted_at, index: true

      t.text      :description

      t.datetime  :event_date
      t.datetime  :time_start
      t.datetime  :time_end

      t.string    :title
      t.string    :location
      t.string    :url

      t.boolean   :public

      t.bigint   :user_creator_id

      t.timestamps
    end

    add_reference   :events, :accounts,    foreign_key: true
    add_reference   :events, :model,       polymorphic: true
    add_reference   :events, :catalog_event_types, foreign_key: true

    add_foreign_key :events, :users, column: :user_creator_id
  end
end