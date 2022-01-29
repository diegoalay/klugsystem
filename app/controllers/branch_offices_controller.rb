class BranchOfficesController < ApplicationSystemController
  before_action :set_branch_office, only: %i[update destroy]

  # GET /branch_offices or /branch_offices.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.branch_offices)
      end
    end
  end

  # GET /branch_offices/1 or /branch_offices/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_branch_office

        respond_with_successful(@branch_office)
      end
    end
  end

  # GET /branch_offices/new
  def new
  end

  # GET /branch_offices/1/edit
  def edit
  end

  # POST /branch_offices or /branch_offices.json
  def create
    @branch_office = @account.branch_offices.new(branch_office_params)
    @branch_office.user_creator = current_user
    @branch_office.user_modifier = current_user

    if @branch_office.save
      respond_with_successful(@branch_office)
    else
      respond_branch_office_with_error
    end
  end

  # PATCH/PUT /branch_offices/1 or /branch_offices/1.json
  def update
    @branch_office.user_modifier = current_user

    if @branch_office.update(branch_office_params)
      respond_with_successful(@branch_office)
    else
      respond_branch_office_with_error
    end
  end

  # DELETE /branch_offices/1 or /branch_offices/1.json
  def destroy
    @branch_office.user_modifier = current_user

    if @branch_office.destroy
      respond_with_successful(@branch_office)
    else
      respond_branch_office_with_error
    end
  end

  private

  def respond_branch_office_with_error
    return respond_with_error(@branch_office.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_branch_office
    @branch_office = @account.branch_offices.find_by(id: params[:id])

    return respond_with_not_found unless @branch_office
  end

  # Only allow a list of trusted parameters through.
  def branch_office_params
    params.fetch(:branch_office, {}).permit(
      %i[
        name telephone postcode postcode street_address street_name
        street_number electronic_billing billing_identifier
      ]
    )
  end
end