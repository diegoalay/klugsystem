class EventsController < ApplicationSystemController
  before_action :set_event, only: %i[update destroy]

  # GET /events or /events.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(EventQuery.new(@account).index(@query))
      end
    end
  end

  # GET /events/1 or /events/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_event

        respond_with_successful(@event)
      end
    end
  end

  # GET /events/new
  def new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events or /events.json
  def create
    @event = @account.events.new(event_params)
    @event.user_creator = current_user
    @event.user_modifier = current_user

    if @event.save
      respond_with_successful(@event)
    else
      respond_event_with_error
    end
  end

  # PATCH/PUT /events/1 or /events/1.json
  def update
    @event.user_modifier = current_user

    if @event.update(event_params)
      respond_with_successful(@event)
    else
      respond_event_with_error
    end
  end

  # DELETE /events/1 or /events/1.json
  def destroy
    @event.user_modifier = current_user

    if @event.destroy
      respond_with_successful(@event)
    else
      respond_event_with_error
    end
  end

  private

  def respond_event_with_error
    return respond_with_error(@event.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = @account.events.find_by(id: params[:id])

    return respond_with_not_found unless @event
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.fetch(:event, {}).permit(
      %i[
        model_type model_id name description date
        time_start time_end title location url public
      ]
    )
  end
end