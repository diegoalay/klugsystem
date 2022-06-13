class Finance::QuotationQuery
  def initialize(account)
    @account = account
    @quotations = account.quotations
  end

  def index(current_user, query)
    search = query[:filters][:search]&.downcase

    quotations = @quotations.select("
      quotations.id,
      quotations.discount,
      quotations.shipping_costs,
      quotations.subtotal,
      quotations.total,
      quotations.discount,
      quotations.interest,
      quotations.received_amount,
      quotations.change,
      quotations.quotation_date,
      quotations.client_name,
      quotations.client_email,
      concat(users.first_name, ' ', users.first_surname) as user_creator_name,
      users.email as user_creator_email,
      quotations.created_at
    ")
    .joins(:user_creator)
    .left_joins(:employee)

    quotations = quotations.where("
      lower(quotations.uuid) like '%#{search}%' or
      lower(users.first_name) like '%#{search}%' or
      lower(users.first_surname) like '%#{search}%' or
      lower(quotations.client_name) like '%#{search}%' or
      lower(quotations.client_email) like '%#{search}%' or
      cast(quotations.subtotal as varchar) like '%#{search}%' or
      cast(quotations.total as varchar) like '%#{search}%' or
      cast(quotations.quotation_date as varchar) like '%#{search}%' or
      lower(concat(users.first_name, ' ', users.first_surname)) like '%#{search}%'
    ") unless search.blank?

    unless query[:filters][:user_creator_type].blank?
      quotations = quotations.where("quotations.user_creator_id = ?", current_user.id) if query[:filters][:user_creator_type].eql? "mine"
    end

    quotations = quotations.where("quotations.payment_method_id = ?", query[:filters][:payment_method]) unless query[:filters][:payment_method].blank?

    quotations = quotations.page(query[:pagination][:current_page])
    .per(query[:pagination][:per_page])
    .order("#{query[:pagination][:order_by]} #{query[:pagination][:order]} nulls last")

    Responder.pagination(quotations)
  end

  def options(current_user)
    {
      quotation_types: ::Sale.fetch_sale_types(current_user),
      user_creator_types: [{ text: 'Mis cotizaciones', value: 'mine'}],
      payment_methods: @account.payment_methods.where(status: true).map {|payment_method| {text: payment_method.name, value: payment_method}}
    }
  end
end