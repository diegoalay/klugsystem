class Administration::RolesController < ::RolesController
  before_action :set_role, only: %i[update destroy]

  # GET /administration/roles or /administration/roles.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@account.roles)
      end
    end
  end

  # GET /administration/roles/1 or /administration/roles/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_role

        respond_with_successful(@role)
      end
    end
  end

  # GET /administration/roles/new
  def new
  end

  # GET /administration/roles/1/edit
  def edit
  end

  # POST /administration/roles or /administration/roles.json
  def create
    @role = @account.roles.new(role_params)
    @role.role_creator = current_role
    @role.role_modifier = current_role

    if @role.save
      respond_with_successful(@role)
    else
      respond_role_with_error
    end
  end

  # PATCH/PUT /administration/roles/1 or /administration/roles/1.json
  def update
    @role.role_modifier = current_role

    if @role.update(role_params)
      respond_with_successful(@role)
    else
      respond_role_with_error
    end
  end

  # DELETE /administration/roles/1 or /administration/roles/1.json
  def destroy
    @role.role_modifier = current_role

    if @role.destroy
      respond_with_successful(@role)
    else
      respond_role_with_error
    end
  end

  private

  def respond_role_with_error
    return respond_with_error(@role.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = @account.roles.find_by(id: params[:id])

    return respond_with_not_found unless @role
  end

  # Only allow a list of trusted parameters through.
  def role_params
    params.fetch(:role, {}).permit(
      %i[first_name last_name  gender birthdate title
        mobile_number telephone fax email note
      ]
    )
  end
end
