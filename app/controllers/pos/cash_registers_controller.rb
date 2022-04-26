class Pos::CashRegistersController < ApplicationSystemController
  def show
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(current_user.current_cash_register&.show)
      end
    end
  end

  def update
    @cash_register = current_user.current_cash_register
    @cash_register.user_modifier = current_user

    if params[:cash_register][:close]
        @cash_register.close_date = Time.current
        @cash_register.final_value = @cash_register.sum_final_value
    end

    if @cash_register.update(cash_register_params)
      respond_with_successful(@cash_register.show)
    else
      respond_cash_register_with_error
    end
  end

  def create
    return respond_with_error("Ya posee una caja abierta.") unless (current_user.current_cash_register.blank?)

    @cash_register = current_user.cash_registers.new(cash_register_params)
    @cash_register.user_modifier = current_user
    @cash_register.open_date = Time.current
    @cash_register.account = current_user.account

    if @cash_register.save
      respond_with_successful(@cash_register.show)
    else
      respond_cash_register_with_error
    end
  end

  def cash_register_params
    params.fetch(:cash_register, {}).permit(
      %i[initial_value]
    )
  end
end
