class Administration::MenuItemsController < ApplicationSystemController
  # GET /menu_items or /menu_items.json
  def index
    respond_to do |format|
      format.json do

        respond_with_successful(MenuItem.all.order(:order))
      end
    end
  end
end
