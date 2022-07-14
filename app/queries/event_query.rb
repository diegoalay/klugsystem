class EventQuery
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

    events = @events.select("
      events.id,
      events.title,
      events.date,
      events.time_start,
      events.time_end,
      events.model_type,
      events.model_id
    ")

    if (query[:filters][:start_date].present? && query[:filters][:end_date].present?)
      events = events.where(
          "events.date >= ? and events.date <= ?",
          "#{DateTime.iso8601(query[:filters][:start_date]).beginning_of_day}",
          "#{DateTime.iso8601(query[:filters][:end_date]).end_of_day}",
      )
    end

    events = events.where("
      lower(events.title) like '%#{search}%'
    ") unless search.blank?

    if (query[:pagination][:disable])
      return events
    end

    events = events.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    Responder.pagination(events)
  end
end
