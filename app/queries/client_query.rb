class ClientQuery
  def initialize(account)
    @clients = account.clients
  end

  def index
    @clients.select("
      id,
      email,
      telephone,
      billing_identifier,
      billing_email,
      billing_address,
      billing_name,
      first_name,
      first_surname,
      concat(
        first_name,
        ' ',
        first_surname
      ) as name
    ")
  end

  def search query
    search = query[:filters][:search]&.downcase
    search.gsub("-", "")

    clients = @clients.select("
      id,
      first_name,
      first_surname,
      billing_identifier,
      billing_email,
      billing_name,
      concat(
        billing_identifier,
        ' [',
        billing_name,
        ']'
      ) as billing_details,
      concat(
        first_name,
        ' ',
        first_surname
      ) as full_name
    ")

    clients = clients.where("
      lower(first_name) like '%#{search}%' or
      lower(first_surname) like '%#{search}%' or
      lower(second_name) like '%#{search}%' or
      lower(second_surname) like '%#{search}%' or
      lower(billing_name) like '%#{search}%' or
      lower(billing_identifier) like '%#{search}%' or
      lower(billing_email) like '%#{search}%'
    ") if search

    clients
  end
end
