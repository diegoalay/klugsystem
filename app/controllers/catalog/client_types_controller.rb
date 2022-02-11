class Catalog::ClientTypesController < ApplicationSystemController
  before_action :set_catalog_client_type, only: %i[update destroy]

  # GET /catalog_client_types or /catalog_client_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.catalog_client_types)
      end
    end
  end

  # GET /catalog_client_types/1 or /catalog_client_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_catalog_client_type

        respond_with_successful(@catalog_client_type)
      end
    end
  end

  # GET /catalog_client_types/new
  def new
  end

  # GET /catalog_client_types/1/edit
  def edit
  end

  # POST /catalog_client_types or /catalog_client_types.json
  def create
    @catalog_client_type = @account.catalog_client_types.new(catalog_client_type_params)
    @catalog_client_type.user_creator = current_user
    @catalog_client_type.user_modifier = current_user

    if @catalog_client_type.save
      respond_with_successful(@catalog_client_type)
    else
      respond_catalog_client_type_with_error
    end
  end

  # PATCH/PUT /catalog_client_types/1 or /catalog_client_types/1.json
  def update
    @catalog_client_type.user_modifier = current_user

    if @catalog_client_type.update(catalog_client_type_params)
      respond_with_successful(@catalog_client_type)
    else
      respond_catalog_client_type_with_error
    end
  end

  # DELETE /catalog_client_types/1 or /catalog_client_types/1.json
  def destroy
    @catalog_client_type.user_modifier = current_user

    if @catalog_client_type.destroy
      respond_with_successful(@catalog_client_type)
    else
      respond_catalog_client_type_with_error
    end
  end

  private

  def respond_catalog_client_type_with_error
    return respond_with_error(@catalog_client_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog_client_type
    @catalog_client_type = @account.catalog_client_types.find_by(id: params[:id])

    return respond_with_not_found unless @catalog_client_type
  end

  # Only allow a list of trusted parameters through.
  def catalog_client_type_params
    params.fetch(:catalog_client_type, {}).permit(
      %i[name]
    )
  end
end