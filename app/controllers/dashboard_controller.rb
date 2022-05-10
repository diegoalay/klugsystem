class DashboardController < ApplicationSystemController
  def default
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(summary)
      end
    end
  end

  private

  def summary
    data = {
      sales_count: 0,
      expeditures_count: 0,
      sales_total: 0,
      expeditures_total: 0,
    }

    if current_user.current_cash_register
      expeditures = expeditures.where(cash_register: self)
      sales = sales.where(cash_register: self, status: true)

      data[:sales_count] = sales.count
      data[:expeditures_count] = expeditures.count
      data[:sales_total] = sales.sum(:total)&.to_f
      data[:expeditures_total] = expeditures.sum(:amount)&.to_f
    end

    return data
  end
end
