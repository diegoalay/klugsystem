namespace :fixes do

  desc 'Fix client information fetching the data from SAT'
  task clients: :environment do
    current_user = Rails.env == "development" ? User.first : User.find(12) # Veterinaria Kaminal sysadmin
    current_user.account.clients.each do |client|
      client_info = DigifactServices::Api.new(current_user).info_nit(client.billing_identifier&.gsub(/[^0-9][A-Z]/, ''))

      unless client_info[:billing_name].blank?
        client.update(billing_name: client_info[:billing_name])
      end
    end
  end
end
