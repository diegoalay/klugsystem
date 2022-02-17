class Expediture < ApplicationRecord
    belongs_to :expediture_type, class_name: "Catalog::ExpeditureType", foreign_key: "catalog_expediture_type_id", optional: true

    belongs_to :cash_register, optional: true

    include LoggerConcern

    validates :description, presence: true

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

    def self.options(account)
      {
        expediture_types: self.expediture_types(account)
      }
    end

    def self.index_options(account)
      {
        expediture_types: self.expediture_types(account)
      }
    end

    private

    def self.expediture_types(account)
      return account.catalog_expediture_types.map { |expediture_type|
        {
          text: expediture_type.name,
          value: expediture_type.id
        }
      }
    end
end