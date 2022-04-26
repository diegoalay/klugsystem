class Pos::ExpedituresController < ::ExpedituresController
  before_action :validate_cash_register

  def validate_cash_register
    unless @current_user.current_cash_register.present?
      redirect_to '/pos/cash_register'
    end
  end
end
