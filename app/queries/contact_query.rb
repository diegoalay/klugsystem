class ContactQuery 
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
          billing_identifier,
          ' [',
          billing_name,
          ']'
        ) as details
      ")
  
      contacts = contacts.where("
        lower(first_name) like '%#{search}%' or
        lower(first_surname) like '%#{search}%' or
        lower(second_name) like '%#{search}%' or
        lower(second_surname) like '%#{search}%'
        telephone like '%#{search}%'
        fax like '%#{search}%'
      ") if search

      contacts
    end
end
