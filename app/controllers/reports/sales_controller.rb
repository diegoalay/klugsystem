class Reports::SalesController < ApplicationSystemController
  def show
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Report::SaleQuery.new(@account).show(current_user, @query))
      end
    end
  end

  def index_options
    respond_with_successful(Report::SaleQuery.new(@account).index_options(current_user))
  end

  def options
    respond_with_successful(Report::SaleQuery.new(@account).options(current_user))
  end
end
