class AddBillingEmployeePresenceToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :billing_employee_presence, :boolean
  end
end
