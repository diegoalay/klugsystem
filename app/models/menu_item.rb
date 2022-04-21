class MenuItem < ApplicationRecord
  has_many :role_menu_items, class_name: '::Role::MenuItem'
  belongs_to :menu_item, optional: :true

  def self.call
    MenuItem.delete_all

    MenuItem.find_or_create_by!(
      order: 0,
      key: 'crm',
      icon: 'user-group'
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 0,
      key: 'crm.clients',
      icon: 'user-group',
      permissions: %w[client.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 1,
      key: 'crm.contacts',
      icon: 'address-card',
      permissions: %w[contact.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'crm'),
      order: 2,
      key: 'crm.events',
      icon: 'calendar-days',
      permissions: %w[event.index]
    )

    MenuItem.find_or_create_by!(
      order: 1,
      key: 'finance',
      icon: 'hand-holding-dollar'
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 1,
      key: 'finance.sales',
      icon: 'file-invoice-dollar',
      permissions: %w[sale.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 2,
      key: 'finance.quotations',
      icon: 'file-invoice',
      permissions: %w[quotation.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'finance'),
      order: 3,
      key: 'finance.expeditures',
      icon: 'money-bill-wave',
      permissions: %w[expediture.index]
    )

    MenuItem.find_or_create_by!(
      order: 3,
      key: 'inventory',
      icon: 'shop'
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 0,
      key: 'inventory.products',
      icon: 'cart-flatbed',
      permissions: %w[products.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 1,
      key: 'inventory.brands',
      icon: 'tags',
      permissions: %w[products.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'inventory'),
      order: 2,
      key: 'inventory.departments',
      icon: 'boxes-stacked',
      permissions: %w[products.index]
    )

    MenuItem.find_or_create_by!(
      order: 4,
      key: 'hr',
      icon: 'address-card',
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'hr'),
      order: 0,
      key: 'hr.employees',
      icon: 'address-card',
      permissions: %w[employees.index]
    )

    MenuItem.find_or_create_by!(
      order: 5,
      key: 'books',
      icon: 'image-portrait',
    )

    MenuItem.find_or_create_by!(
      order: 10,
      key: 'administration',
      icon: 'gears',
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 0,
      key: 'administration.users',
      icon: 'users',
      permissions: %w[users.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 1,
      key: 'administration.roles',
      icon: 'user-shield',
      permissions: %w[roles.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 2,
      key: 'administration.branch_offices',
      icon: 'warehouse',
      permissions: %w[branch_offices.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 3,
      key: 'administration.payment_methods',
      icon: 'money-bill-wave',
      permissions: %w[payment_methods.index]
    )

    MenuItem.find_or_create_by!(
      menu_item: MenuItem.find_by(key: 'administration'),
      order: 4,
      key: 'administration.digifact',
      icon: 'receipt',
      permissions: %w[digifact.show]
    )
  end
end