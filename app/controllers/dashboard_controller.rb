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
      final_value: 0
    }

    cash_register = current_user.current_cash_register

    if cash_register.present?
      expeditures = @account.expeditures.where(cash_register: self)
      sales = @account.sales.where(cash_register: self, status: true)

      sales_sum = sales.sum(:total)&.to_f
      expeditures_sum =  expeditures.sum(:amount)&.to_f

      final_value = (cash_register.initial_value + sales_sum - expeditures_sum)

      data[:sales_count] = sales.count
      data[:expeditures_count] = expeditures.count
      data[:sales_total] = sales_sum
      data[:expeditures_total] = expeditures_sum
      data[:final_value] = final_value
    end

    return data
  end
end
