class Reports::SaleDetailsController < ApplicationSystemController
  def show
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Report::SaleDetailsQuery.new(@account).show(current_user, @query))
      end
    end
  end

  def options
    respond_with_successful(Report::SaleDetailsQuery.new(@account).options(current_user))
  end
end
