class Crm::ContactQuery 
    def initialize(account)
      @contacts = account.contacts 
    end

    def index 
      @contacts.select("
        id,
        email,
        telephone,
        fax,
        mobile_number,
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
  
      contacts = @contacts.select("
        id,
        first_name,
        first_surname,
        telephone,
        fax,
        concat(
          first_name,
          ' ',
          first_surname
        ) as full_name
      ")

      contacts = contacts.where("
        lower(first_name) like '%#{search}%' or
        lower(first_name) like '%#{search}%' or
        lower(first_surname) like '%#{search}%' or
        lower(second_name) like '%#{search}%' or
        lower(second_surname) like '%#{search}%' or 
        telephone like '%#{search}%' or 
        fax like '%#{search}%' or 
        concat(
          first_name,
          ' ',
          first_surname
        ) like '%#{search}%'
      ") if search

      contacts
    end
end
