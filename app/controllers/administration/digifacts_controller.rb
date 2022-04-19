class Administration::DigifactsController < ApplicationSystemController
  def show
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(@account.digifact_details)
      end
    end
  end

  def update
    # @account.user_modifier = current_user

    @account.assign_attributes(digifact_params)

    if @account.save
      respond_with_successful(@account.digifact_details)
    else
      respond_account_with_error
    end
  end

  def validate
    DigifactServices::Authentication.new(@account).call(true)

    if (@account.digifact_token.present?)
      respond_with_successful(@account.digifact_details)
    else
      respond_with_error(@account.digifact_errors)
    end
  end

  private

  def digifact_params
    params.fetch(:digifact, {}).permit(
      %i[digifact_billing_identifier digifact_user digifact_password]
    )
  end
end
