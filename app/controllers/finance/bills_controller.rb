class Finance::BillsController < ::SalesController
  def options
    respond_with_successful(Finance::BillQuery.new(@account).options)
  end
end
