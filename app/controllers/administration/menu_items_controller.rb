class Administration::MenuItemsController < ApplicationSystemController
  # GET /menu_items or /menu_items.json
  def index
    respond_to do |format|
      format.json do

        items = MenuItem.all.order(:order, :key).map do |item|
          text = item.menu_item.present? ? I18n.t("sidebar.#{item.key}") : I18n.t("sidebar.#{item.key}.title")

          item.attributes.merge({
            text: text
          })
        end

        respond_with_successful(items)
      end
    end
  end
end
