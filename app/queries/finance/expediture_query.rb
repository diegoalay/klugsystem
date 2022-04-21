

class Finance::ExpeditureQuery
  def initialize(account)
    @account = account
    @expeditures = account.expeditures
  end

  def index(query)
    expeditures = @expeditures.select(
      "id",
      "amount",
      "description",
      "expediture_date",
      "expediture_types.name as expediture_type_name"
    )
    .left_joins(:expediture_type)

    expeditures = expeditures.where("expediture_types.id = ?", query[:filters][:expediture_type]) unless query[:filters][:expediture_type].blank?
    expeditures = expeditures.where("expeditures.cash_register_id = ?", query[:filters][:cash_register_id]) unless query[:filters][:cash_register_id].blank?

    expeditures
  end

  def options
    {
      expediture_types: expediture_types
    }
  end

  def index_options
    {
      expediture_types: expediture_types
    }
  end

  def expediture_types
    return @account.expediture_types.map { |expediture_type|
      {
        text: expediture_type.name,
        value: expediture_type.id
      }
    }
  end
end