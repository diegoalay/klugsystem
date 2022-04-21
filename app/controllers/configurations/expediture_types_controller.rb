class Configurations::ExpeditureTypesController < ApplicationSystemController
  before_action :set_expediture_type, only: %i[update destroy]

  # GET /expediture_types or /expediture_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.expediture_types)
      end
    end
  end

  # GET /expediture_types/1 or /expediture_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_expediture_type

        respond_with_successful(@expediture_type)
      end
    end
  end

  # GET /expediture_types/new
  def new
  end

  # GET /expediture_types/1/edit
  def edit
  end

  # POST /expediture_types or /expediture_types.json
  def create
    @expediture_type = @account.expediture_types.new(expediture_type_params)
    @expediture_type.user_creator = current_user
    @expediture_type.user_modifier = current_user

    if @expediture_type.save
      respond_with_successful(@expediture_type)
    else
      respond_expediture_type_with_error
    end
  end

  # PATCH/PUT /expediture_types/1 or /expediture_types/1.json
  def update
    @expediture_type.user_modifier = current_user

    if @expediture_type.update(expediture_type_params)
      respond_with_successful(@expediture_type)
    else
      respond_expediture_type_with_error
    end
  end

  # DELETE /expediture_types/1 or /expediture_types/1.json
  def destroy
    @expediture_type.user_modifier = current_user

    if @expediture_type.destroy
      respond_with_successful(@expediture_type)
    else
      respond_expediture_type_with_error
    end
  end

  private

  def respond_expediture_type_with_error
    return respond_with_error(@expediture_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_expediture_type
    @expediture_type = @account.expediture_types.find_by(id: params[:id])

    return respond_with_not_found unless @expediture_type
  end

  # Only allow a list of trusted parameters through.
  def expediture_type_params
    params.fetch(:expediture_type, {}).permit(
      %i[name note]
    )
  end
end