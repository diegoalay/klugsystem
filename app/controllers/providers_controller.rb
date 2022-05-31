class ProvidersController < ApplicationSystemController
  before_action :set_provider, only: %i[update destroy]

  # GET /providers or /providers.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.providers)
      end
    end
  end

  # GET /providers/1 or /providers/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_provider

        respond_with_successful(@provider)
      end
    end
  end

  # GET /providers/new
  def new
  end

  # POST /providers or /providers.json
  def create
    @provider = @account.providers.new(provider_params)
    @provider.user_creator = current_user
    @provider.user_modifier = current_user

    if @provider.save
      respond_with_successful(@provider)
    else
      respond_provider_with_error
    end
  end

  # PATCH/PUT /providers/1 or /providers/1.json
  def update
    @provider.user_modifier = current_user

    if @provider.update(provider_params)
      respond_with_successful(@provider)
    else
      respond_provider_with_error
    end
  end

  # DELETE /providers/1 or /providers/1.json
  def destroy
    @provider.user_modifier = current_user

    if @provider.destroy
      respond_with_successful(@provider)
    else
      respond_provider_with_error
    end
  end

  private

  def respond_provider_with_error
    return respond_with_error(@provider.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_provider
    @provider = @account.providers.find_by(id: params[:id])

    return respond_with_not_found unless @provider
  end

  # Only allow a list of trusted parameters through.
  def provider_params
    params.fetch(:provider, {}).permit(
      %i[
        company_name billing_name billing_identifier billing_address
        billing_department billing_municipality address email telephone
        billing_postcode fax website mobile_number
      ]
    )
  end
end
