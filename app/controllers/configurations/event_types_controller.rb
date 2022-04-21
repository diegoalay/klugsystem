class Configuration::EventTypesController < ApplicationSystemController
  before_action :set_event_type, only: %i[update destroy]

  # GET /event_types or /event_types.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.event_types)
      end
    end
  end

  # GET /event_types/1 or /event_types/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_event_type

        respond_with_successful(@event_type)
      end
    end
  end

  # GET /event_types/new
  def new
  end

  # GET /event_types/1/edit
  def edit
  end

  # POST /event_types or /event_types.json
  def create
    @event_type = @account.event_types.new(event_type_params)
    @event_type.user_creator = current_user
    @event_type.user_modifier = current_user

    if @event_type.save
      respond_with_successful(@event_type)
    else
      respond_event_type_with_error
    end
  end

  # PATCH/PUT /event_types/1 or /event_types/1.json
  def update
    @event_type.user_modifier = current_user

    if @event_type.update(event_type_params)
      respond_with_successful(@event_type)
    else
      respond_event_type_with_error
    end
  end

  # DELETE /event_types/1 or /event_types/1.json
  def destroy
    @event_type.user_modifier = current_user

    if @event_type.destroy
      respond_with_successful(@event_type)
    else
      respond_event_type_with_error
    end
  end

  private

  def respond_event_type_with_error
    return respond_with_error(@event_type.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event_type
    @event_type = @account.event_types.find_by(id: params[:id])

    return respond_with_not_found unless @event_type
  end

  # Only allow a list of trusted parameters through.
  def event_type_params
    params.fetch(:event_type, {}).permit(
      %i[name note]
    )
  end
end