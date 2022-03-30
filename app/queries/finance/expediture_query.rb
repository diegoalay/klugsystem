

class Finance::SaleQuery 
  def initialize(account)
    @account = account
    @expeditures = account.expeditures
  end

  def self.index(account, query)
    expeditures = account.expeditures.select(
      "id",
      "amount",
      "description",
      "expediture_date",
      "catalog_expediture_types.name as expediture_type_name"
    )
    .left_joins(:expediture_type)

    expeditures = expeditures.where("catalog_expediture_types.id = ?", query[:filters][:expediture_type]) unless query[:filters][:expediture_type].blank?
    expeditures = expeditures.where("expeditures.cash_register_id = ?", query[:filters][:cash_register_id]) unless query[:filters][:cash_register_id].blank?

    expeditures
  end
  
  def options
    {
      expediture_types: expediture_types
    }
  end

  def self.index_options
    {
      expediture_types: expediture_types
    }
  end

  def expediture_types
    return @account.catalog_expediture_types.map { |expediture_type|
      {
        text: expediture_type.name,
        value: expediture_type.id
      }
    }
  end
end