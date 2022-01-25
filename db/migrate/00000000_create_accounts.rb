class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string  :name
      t.string  :direction
      t.string  :telephone
      t.string  :billing_identifier
      t.string  :billing_name
      t.string  :billing_direction

      t.text    :description

      t.integer :status

      t.timestamps
    end
  end
end