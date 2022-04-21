class Configuration::ClientTypesController < ApplicationSystemController
  before_action :set_client_type, only: %i[update destroy]

  # GET /client_types or /client_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.client_types)
      end
    end
  end

  # GET /client_types/1 or /client_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_client_type

        respond_with_successful(@client_type)
      end
    end
  end

  # GET /client_types/new
  def new
  end

  # GET /client_types/1/edit
  def edit
  end

  # POST /client_types or /client_types.json
  def create
    @client_type = @account.client_types.new(client_type_params)
    @client_type.user_creator = current_user
    @client_type.user_modifier = current_user

    if @client_type.save
      respond_with_successful(@client_type)
    else
      respond_client_type_with_error
    end
  end

  # PATCH/PUT /client_types/1 or /client_types/1.json
  def update
    @client_type.user_modifier = current_user

    if @client_type.update(client_type_params)
      respond_with_successful(@client_type)
    else
      respond_client_type_with_error
    end
  end

  # DELETE /client_types/1 or /client_types/1.json
  def destroy
    @client_type.user_modifier = current_user

    if @client_type.destroy
      respond_with_successful(@client_type)
    else
      respond_client_type_with_error
    end
  end

  private

  def respond_client_type_with_error
    return respond_with_error(@client_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_client_type
    @client_type = @account.client_types.find_by(id: params[:id])

    return respond_with_not_found unless @client_type
  end

  # Only allow a list of trusted parameters through.
  def client_type_params
    params.fetch(:client_type, {}).permit(
      %i[name note]
    )
  end
end