class Account < ApplicationRecord
  include EncryptableConcern
  include LoggerConcern

  encryptable_json_fields(:digifact, 'digifact_user', 'digifact_password')

  has_many :sales_details, class_name: 'Sale::Detail'
  has_many :measurement_units
  has_many :payment_methods
  has_many :billing_fields
  has_many :bill_templates
  has_many :branch_offices
  has_many :cash_registers
  has_many :expeditures
  has_many :departments
  has_many :quotations
  has_many :employees
  has_many :providers
  has_many :products
  has_many :contacts
  has_many :clients
  has_many :events
  has_many :brands
  has_many :users
  has_many :roles
  has_many :sales


  #Configurations
  has_many :client_types
  has_many :event_types
  has_many :expediture_types
  has_many :product_transaction_types

  after_create :setup_account

  store_accessor :digifact, :digifact_token_expires_at, :digifact_token, :digifact_valid, :digifact_errors,
                            :digifact_billing_identifier, :digifact_user, :digifact_password, :digifact_status

  # attribute :sale_types, :jsonb, default: ['sale', 'receipt', 'bill', 'electronic_bill']

  def setup_account
    # create default sale catalog type
    type = product_transaction_types.find_or_create_by!(code: 'product-sale', name: 'Venta')

    # create default admin role
    roles.find_or_create_by!(name: 'Admin', code: 'admin')

    # create default client
    clients.find_or_initialize_by(billing_identifier: 'CF') do |record|
      record.billing_address = ''
      record.billing_name = 'CF'
      record.billing_address = '-'
      record.save(validate: false)
    end
  end

  def product_transaction_sale_type
    return product_transaction_types.find_by(code: 'product-sale')
  end

  def digifact_valid?
    return true if digifact_token

    return false
  end

  def digifact_details
    {
      digifact_token_expires_at: digifact_token_expires_at,
      digifact_billing_identifier: digifact_billing_identifier,
      digifact_user: digifact_user,
      digifact_password: digifact_password,
      digifact_status: digifact_status,
      digifact_errors: digifact_errors
    }
  end

  def digifact_username
    ['GT', '.', digifact_billing_identifier, '.', digifact_user].join
  end

  def digifact_authentication_token
    DigifactServices::Authentication.new(self).call

    digifact_token
  end

  def self.options
    {
      sale_types: ::Sale.sale_types.map do |k, v|
        {
          text: I18n.t("models.sales.column_enum_sale_type_#{k}"),
          value: v
        }
      end
    }
  end

  def logo
    if logo_exists?
      return "account/#{id}/logo.png"
    end

    nil
  end

  def quotation_path
    if custom_quotation_pdf?
      "quotations/#{id}/show.pdf.html.erb"
    else
      "quotations/show.pdf.html.erb"
    end
  end

  def walmart_billing?
    return true
  end

  def custom_quotation_pdf?
    if File.file?("#{Rails.root}/app/views/quotations/#{id}/show.pdf.html.erb")
      return true
    end

    false
  end

  def logo_exists?
    if File.file?("#{Rails.root}/assets/images/account/#{id}.png")
      return true
    end

    false
  end
end