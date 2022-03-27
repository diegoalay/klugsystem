class Crm::EventsController < ::EventsController
  def index
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(Crm::EventQuery.new(@account).index(@query))
      end
    end
  end
end