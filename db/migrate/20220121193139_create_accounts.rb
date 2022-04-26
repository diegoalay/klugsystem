class CreateAccounts < ActiveRecord::Migration[6.1]
  def change
    create_table :accounts do |t|
      t.string  :name
      t.string  :direction
      t.string  :telephone
      t.string  :email
      t.string  :website

      t.string  :billing_identifier
      t.string  :billing_name
      t.string  :billing_direction
      t.boolean :electronic_billing

      t.text    :description

      t.integer :status

      # Users Relations
      t.bigint :user_creator_id
      t.bigint :user_modifier_id

      t.timestamps
    end
  end
end