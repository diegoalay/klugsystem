class Crm::EventQuery < EventQuery
  def initialize(account)
    @events = account.events
    .where(
      "model_type = ? or 
      model_type = ?",
      'Contact',
      'Client'
    )
    .includes(:model)
  end

  def index(query)
    search = query.dig(:filters, :search)&.downcase

    events = @events
    .joins("
      inner join (
        select 
          concat(
            first_name, 
            ' ',
            first_surname
          ) as model_identifier,
          id as model_id,
          'Client' as type
        from clients
        union  
        select 
          concat(
            first_name, 
            ' ',
            first_surname
          ) as full_name,
          id as model_identifier,
          'Contact' as type
        from contacts 
      ) as people 
        on people.type = events.model_type
        and people.model_id = events.model_id
    ")
    .select("
      events.id,
      events.title,
      events.date,
      events.time_start,
      events.time_end,
      events.model_type,
      events.model_id,
      people.model_identifier
    ")

    events = events.where("
      lower(events.title) like '%#{search}%' or
      lower(people.model_identifier) like '%#{search}%'
    ") unless search.blank?

    if (query[:pagination][:disable])
      return events
    end 
    
    events = events.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    Responder.pagination(
      events
    )
  end
end
