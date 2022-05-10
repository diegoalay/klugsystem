class Administration::UsersController < ::UsersController
  before_action :set_user, only: %i[update destroy]

  # GET /administration/users or /administration/users.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Administration::UserQuery.new(@account).index)
      end
    end
  end

  # GET /administration/users/1 or /administration/users/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_user

        respond_with_successful(@user.show)
      end
    end
  end

  # GET /administration/users/new
  def new
  end

  # GET /administration/users/1/edit
  def edit
  end

  # POST /administration/users or /administration/users.json
  def create
    @user = @account.users.new(user_params)
    @user.user_creator = current_user
    @user.user_modifier = current_user
    @user.password = SecureRandom.hex

    if @user.save
      set_user_role

      respond_with_successful(@user)
    else
      respond_user_with_error
    end
  end

  # PATCH/PUT /administration/users/1 or /administration/users/1.json
  def update
    @user.user_modifier = current_user
    set_user_role
    if @user.update(user_params)
      respond_with_successful(@user.show)
    else
      respond_user_with_error
    end
  end

  # DELETE /administration/users/1 or /administration/users/1.json
  def destroy
    @user.user_modifier = current_user

    if @user.destroy
      respond_with_successful(@user.show)
    else
      respond_user_with_error
    end
  end

  def options
    respond_with_successful(Administration::UserQuery.new(@account).options)
  end

  private

  def set_user_role
    user_role = User::Role.find_or_initialize_by(user: @user)
    user_role.role_id = params[:user][:role_id]
    user_role.save!
  end

  def respond_user_with_error
    return respond_with_error(@user.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = @account.users.find_by(id: params[:id])

    return respond_with_not_found unless @user
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(
      %i[first_name last_name  first_surname gender birthdate title
        mobile_number telephone fax email branch_office_id
      ]
    )
  end
end
