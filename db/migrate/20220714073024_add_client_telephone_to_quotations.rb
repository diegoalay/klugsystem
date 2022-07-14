class AddClientTelephoneToQuotations < ActiveRecord::Migration[6.1]
  def change
    add_column :quotations, :client_telephone, :string
  end
end
