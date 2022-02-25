class Catalog::ExpeditureTypesController < ApplicationSystemController
  before_action :set_catalog_expediture_type, only: %i[update destroy]

  # GET /catalog_expediture_types or /catalog_expediture_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.catalog_expediture_types)
      end
    end
  end

  # GET /catalog_expediture_types/1 or /catalog_expediture_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_catalog_expediture_type

        respond_with_successful(@catalog_expediture_type)
      end
    end
  end

  # GET /catalog_expediture_types/new
  def new
  end

  # GET /catalog_expediture_types/1/edit
  def edit
  end

  # POST /catalog_expediture_types or /catalog_expediture_types.json
  def create
    @catalog_expediture_type = @account.catalog_expediture_types.new(catalog_expediture_type_params)
    @catalog_expediture_type.user_creator = current_user
    @catalog_expediture_type.user_modifier = current_user

    if @catalog_expediture_type.save
      respond_with_successful(@catalog_expediture_type)
    else
      respond_catalog_expediture_type_with_error
    end
  end

  # PATCH/PUT /catalog_expediture_types/1 or /catalog_expediture_types/1.json
  def update
    @catalog_expediture_type.user_modifier = current_user

    if @catalog_expediture_type.update(catalog_expediture_type_params)
      respond_with_successful(@catalog_expediture_type)
    else
      respond_catalog_expediture_type_with_error
    end
  end

  # DELETE /catalog_expediture_types/1 or /catalog_expediture_types/1.json
  def destroy
    @catalog_expediture_type.user_modifier = current_user

    if @catalog_expediture_type.destroy
      respond_with_successful(@catalog_expediture_type)
    else
      respond_catalog_expediture_type_with_error
    end
  end

  private

  def respond_catalog_expediture_type_with_error
    return respond_with_error(@catalog_expediture_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog_expediture_type
    @catalog_expediture_type = @account.catalog_expediture_types.find_by(id: params[:id])

    return respond_with_not_found unless @catalog_expediture_type
  end

  # Only allow a list of trusted parameters through.
  def catalog_expediture_type_params
    params.fetch(:catalog_expediture_type, {}).permit(
      %i[name note]
    )
  end
end