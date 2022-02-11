class Catalog::EventTypesController < ApplicationSystemController
  before_action :set_catalog_event_type, only: %i[update destroy]

  # GET /catalog_event_types or /catalog_event_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.catalog_event_types)
      end
    end
  end

  # GET /catalog_event_types/1 or /catalog_event_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_catalog_event_type

        respond_with_successful(@catalog_event_type)
      end
    end
  end

  # GET /catalog_event_types/new
  def new
  end

  # GET /catalog_event_types/1/edit
  def edit
  end

  # POST /catalog_event_types or /catalog_event_types.json
  def create
    @catalog_event_type = @account.catalog_event_types.new(catalog_event_type_params)
    @catalog_event_type.user_creator = current_user
    @catalog_event_type.user_modifier = current_user

    if @catalog_event_type.save
      respond_with_successful(@catalog_event_type)
    else
      respond_catalog_event_type_with_error
    end
  end

  # PATCH/PUT /catalog_event_types/1 or /catalog_event_types/1.json
  def update
    @catalog_event_type.user_modifier = current_user

    if @catalog_event_type.update(catalog_event_type_params)
      respond_with_successful(@catalog_event_type)
    else
      respond_catalog_event_type_with_error
    end
  end

  # DELETE /catalog_event_types/1 or /catalog_event_types/1.json
  def destroy
    @catalog_event_type.user_modifier = current_user

    if @catalog_event_type.destroy
      respond_with_successful(@catalog_event_type)
    else
      respond_catalog_event_type_with_error
    end
  end

  private

  def respond_catalog_event_type_with_error
    return respond_with_error(@catalog_event_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog_event_type
    @catalog_event_type = @account.catalog_event_types.find_by(id: params[:id])

    return respond_with_not_found unless @catalog_event_type
  end

  # Only allow a list of trusted parameters through.
  def catalog_event_type_params
    params.fetch(:catalog_event_type, {}).permit(
      %i[name]
    )
  end
end