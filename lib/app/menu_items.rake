
namespace :app do
  namespace :menu_items do
    desc "Creates the menu items of the platform"
      task build: :environment do
        ActiveRecord::Base.transaction do
          MenuItem.find_or_create_by!(
            order: 0,
            key: 'crm',
            icon: 'user-friends'
          )

          MenuItem.find_or_create_by!(
            menu_item: MenuItem.find_by(key: 'crm'),
            order: 0,
            key: 'crm.clients',
            icon: 'user-friends',
            permissions: %w[client.index]
          )

          MenuItem.find_or_create_by!(
            order: 1,
            key: 'crm.contacts',
            icon: 'fa-address-book',
            permissions: %w[contact.index]
          )

          MenuItem.find_or_create_by!(
            menu_item: MenuItem.find_by(key: 'crm'),
            order: 2,
            key: 'crm.events',
            icon: 'fa-address-book',
            permissions: %w[event.index]
          )
      end
    end
  end
end