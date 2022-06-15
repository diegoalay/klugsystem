class Reports::SalesController < ApplicationSystemController
  def show
    instance = Report::SaleQuery.new(@account)

    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(instance.show(current_user, @query))
      end
      format.pdf do
        sales = instance.index(current_user, @query)

        send_data DocumentGeneratorServices::CombinePdfService.new(sales, current_user).call,
                  filename: "Facturas.pdf",
                  type: "application/pdf"
      end
    end
  end

  def options
    respond_with_successful(Report::SaleQuery.new(@account).options(current_user, @query))
  end
end
