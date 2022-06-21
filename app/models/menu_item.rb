class MenuItem < ApplicationRecord
  has_many :role_menu_items, class_name: '::Role::MenuItem'
  belongs_to :menu_item, optional: :true

  def self.call_new
    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 5,
      key: 'finance.bills',
      icon: 'receipt',
      permissions: %w[bill.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 6,
      key: 'finance.bill_templates',
      icon: 'file-lines',
      permissions: %w[bill_template.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 5,
      key: 'administration.billing_fields',
      icon: 'circle-plus',
      permissions: %w[billing_field.show]
    ).save!

    MenuItem.find_by(key: 'administration.account').update(order: 6)
  end

  def self.call
    # MenuItem.delete_all

    MenuItem.find_or_initialize_by(
      order: 0,
      key: 'crm',
      icon: 'user-group'
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 0,
      key: 'crm.clients',
      icon: 'user-group',
      permissions: %w[client.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 1,
      key: 'crm.contacts',
      icon: 'address-card',
      permissions: %w[contact.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 2,
      key: 'crm.events',
      icon: 'calendar-days',
      permissions: %w[event.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 1,
      key: 'finance',
      icon: 'hand-holding-dollar'
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 1,
      key: 'finance.sales',
      icon: 'file-invoice-dollar',
      permissions: %w[sale.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 2,
      key: 'finance.quotations',
      icon: 'file-invoice',
      permissions: %w[quotation.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 3,
      key: 'finance.expeditures',
      icon: 'money-bill-wave',
      permissions: %w[expediture.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 4,
      key: 'finance.cash_registers',
      icon: 'cash-register',
      permissions: %w[cash_register.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 3,
      key: 'inventory',
      icon: 'shop'
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 0,
      key: 'inventory.products',
      icon: 'cart-flatbed',
      permissions: %w[products.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 1,
      key: 'inventory.brands',
      icon: 'tags',
      permissions: %w[products.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 2,
      key: 'inventory.departments',
      icon: 'boxes-stacked',
      permissions: %w[products.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 3,
      key: 'inventory.measurement_units',
      icon: 'ruler',
      permissions: %w[measurement_unit.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 4,
      key: 'pos',
      icon: 'store'
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'pos'),
      order: 0,
      key: 'pos.cash_register',
      icon: 'cash-register',
      permissions: %w[cash_register.show]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'pos'),
      order: 1,
      key: 'pos.sales',
      icon: 'file-invoice-dollar',
      permissions: %w[sales.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'pos'),
      order: 2,
      key: 'pos.expeditures',
      icon: 'money-bill-wave',
      permissions: %w[expeditures.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 4,
      key: 'hr',
      icon: 'address-card',
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'hr'),
      order: 0,
      key: 'hr.employees',
      icon: 'address-card',
      permissions: %w[employees.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 6,
      key: 'books',
      icon: 'image-portrait',
    ).save!

    MenuItem.find_or_initialize_by(
      order: 7,
      key: 'configurations',
      icon: 'screwdriver-wrench',
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'configurations'),
      order: 0,
      key: 'configurations.client_types',
      icon: 'briefcase',
      permissions: %w[client_types.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'configurations'),
      order: 1,
      key: 'configurations.expediture_types',
      icon: 'money-bill',
      permissions: %w[client_types.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'configurations'),
      order: 2,
      key: 'configurations.event_types',
      icon: 'calendar-check',
      permissions: %w[event_types.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'configurations'),
      order: 3,
      key: 'configurations.product_transaction_types',
      icon: 'truck-ramp-box',
      permissions: %w[product_transaction_types.index]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 10,
      key: 'administration',
      icon: 'gears',
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 0,
      key: 'administration.users',
      icon: 'users',
      permissions: %w[users.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 1,
      key: 'administration.roles',
      icon: 'user-shield',
      permissions: %w[roles.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 2,
      key: 'administration.branch_offices',
      icon: 'warehouse',
      permissions: %w[branch_offices.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 3,
      key: 'administration.payment_methods',
      icon: 'money-bill-wave',
      permissions: %w[payment_methods.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 4,
      key: 'administration.digifact',
      icon: 'receipt',
      permissions: %w[digifact.show]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 5,
      key: 'administration.account',
      icon: 'gear',
      permissions: %w[account.show]
    ).save!

    MenuItem.find_or_initialize_by(
      order: 6,
      key: 'reports',
      icon: 'file-arrow-down'
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'reports'),
      order: 0,
      key: 'reports.sales',
      icon: 'chart-line',
      permissions: %w[sales.index]
    ).save!

    MenuItem.find_or_initialize_by(
      menu_item: MenuItem.find_by(key: 'reports'),
      order: 0,
      key: 'reports.sale_details',
      icon: 'chart-column',
      permissions: %w[sale_details.index]
    ).save!
  end
end
