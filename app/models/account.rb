class Account < ApplicationRecord
  has_many :payment_methods,   class_name: 'PaymentMethod'
  has_many :branch_offices,    class_name: 'BranchOffice'
  has_many :cash_registers,    class_name: 'CashRegister'
  has_many :sales_details,     class_name: 'Sale::Detail'
  has_many :expeditures,       class_name: 'Expediture'
  has_many :departments,       class_name: 'Department'
  has_many :quotations,        class_name: 'Quotation'
  has_many :employees,         class_name: 'Employee'
  has_many :products,          class_name: 'Product'
  has_many :contacts,          class_name: 'Contact'
  has_many :clients,           class_name: 'Client'
  has_many :events,            class_name: 'Event'
  has_many :brands,            class_name: 'Brand'
  has_many :users,             class_name: 'User'
  has_many :sales,             class_name: 'Sale'


  # Catalogs
  has_many :catalog_client_types,               class_name: 'Catalog::ClientType'
  has_many :catalog_event_types,                class_name: 'Catalog::EventType'
  has_many :catalog_expediture_types,           class_name: 'Catalog::ExpeditureType'
  has_many :catalog_product_transaction_types,  class_name: 'Catalog::ProductTransactionType'

  after_create :setup_account

  def setup_account
    # create default sale catalog type
    type = catalog_product_transaction_types.find_or_create_by!(name: 'Venta')

    type.update(code: 'product-sale') # special code

    # create default client
    clients.find_or_initialize_by(billing_identifier: 'cf') do |record|
      record.billing_address = '-'
      record.billing_name = '-'
      record.save!
    end
  end

  def catalog_product_transaction_sale_type
    return catalog_product_transaction_types.find_by(code: 'product-sale')
  end
end