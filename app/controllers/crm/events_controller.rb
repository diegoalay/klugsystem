class Crm::EventsController < ApplicationSystemController
  def index
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(ContactQuery.new(@account).index)
      end
    end
  end
end