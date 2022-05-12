class AddBillingFraseAndBillingStageToAccounts < ActiveRecord::Migration[6.1]
  def change
    add_column :accounts, :billing_phrase, :string
    add_column :accounts, :billing_stage, :string
  end
end
