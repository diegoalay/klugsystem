class Inventory::MeasurementUnitsController < ::MeasurementUnitsController
  before_action :set_measurement_unit, only: %i[update destroy]

  # GET /inventory/measurement_units or /inventory/measurement_units.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.measurement_units)
      end
    end
  end

  # GET /inventory/measurement_units/1 or /inventory/measurement_units/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_measurement_unit

        return respond_with_not_found unless @measurement_unit

        respond_with_successful(@measurement_unit)
      end
    end
  end

  # GET /inventory/measurement_units/new
  def new
  end

  # GET /inventory/measurement_units/1/edit
  def edit
  end

  # POST /inventory/measurement_units or /inventory/measurement_units.json
  def create
    @measurement_unit = @account.measurement_units.new(measurement_unit_params)
    @measurement_unit.user_creator = current_user
    @measurement_unit.user_modifier = current_user

    if @measurement_unit.save
      respond_with_successful(@measurement_unit)
    else
      respond_measurement_unit_with_error
    end
  end

  # PATCH/PUT /inventory/measurement_units/1 or /inventory/measurement_units/1.json
  def update
    return respond_with_not_found unless @measurement_unit

    @measurement_unit.user_modifier = current_user

    if @measurement_unit.update(measurement_unit_params)
      respond_with_successful(@measurement_unit)
    else
      respond_measurement_unit_with_error
    end
  end

  # DELETE /inventory/measurement_units/1 or /inventory/measurement_units/1.json
  def destroy
    return respond_with_not_found unless @measurement_unit

    @measurement_unit.user_modifier = current_user

    if @measurement_unit.destroy
      respond_with_successful(@measurement_unit)
    else
      respond_measurement_unit_with_error
    end
  end

  private

  def respond_measurement_unit_with_error
    return respond_with_error(@measurement_unit.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_measurement_unit
    @measurement_unit = @account.measurement_units.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def measurement_unit_params
    params.fetch(:measurement_unit, {}).permit(
      %i[name]
    )
  end
end
