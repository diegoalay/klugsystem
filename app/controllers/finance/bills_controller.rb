class Finance::BillsController < ::SalesController
  def options
    respond_with_successful(Finance::BillQuery.new(@account).options(current_user))
  end
end
