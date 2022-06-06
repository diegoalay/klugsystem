class CreateAccountBillingFieldActivities < ActiveRecord::Migration[6.1]
  def change
    table_base_structure = JSON.parse(File.read(Rails.root.join("db","structure","activities.json")))

    create_table :account_billing_field_activities do |t|
      table_base_structure.each do |column|
        t.send(
          column["type"].parameterize.underscore.to_sym,
          !!column["index"] ?
            "#{column["name"].parameterize.underscore.to_sym}, index: true" :
            column["name"].parameterize.underscore.to_sym
        )
      end

      t.timestamps
    end

    add_reference   :account_billing_field_activities, :account_billing_field, foreign_key: true, index: { name: "account_billing_field_activities_billing_field" }

    add_foreign_key :account_billing_field_activities, :users,   column: :user_creator_id
    add_foreign_key :account_billing_field_activities, :users,   column: :user_modifier_id
  end
end
