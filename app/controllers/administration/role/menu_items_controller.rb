class Administration::Role::MenuItemsController < ApplicationController
  before_action :set_role, only: %i[index create]
  before_action :set_role_menu_item, only: %i[update destroy]

  # GET /administration/1/role_menu_items or /administration/1/role_menu_items.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(@role.menu_items)
      end
    end
  end

  # GET /administration/1/role_menu_items/1 or /administration/1/role_menu_items/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_role_menu_item

        respond_with_successful(@role_menu_item)
      end
    end
  end

  # GET /administration/1/role_menu_items/new
  def new
  end

  # GET /administration/1/role_menu_items/1/edit
  def edit
  end

  # POST /administration/1/role_menu_items or /administration/1/role_menu_items.json
  def create
    @role_menu_item = @role.role_menu_items.new(role_menu_item_params)
    @role_menu_item.user_creator = current_user
    @role_menu_item.user_modifier = current_user

    if @role_menu_item.save
      respond_with_successful(@role_menu_item)
    else
      respond_role_menu_item_with_error
    end
  end

  # PATCH/PUT /administration/1/role_menu_items/1 or /administration/1/role_menu_items/1.json
  def update
    @role_menu_item.user_modifier = current_user

    if @role_menu_item.update(role_menu_item_params)
      respond_with_successful(@role_menu_item)
    else
      respond_role_menu_item_with_error
    end
  end

  # DELETE /administration/1/role_menu_items/1 or /administration/1/role_menu_items/1.json
  def destroy
    @role_menu_item.user_modifier = current_user

    if @role_menu_item.destroy
      respond_with_successful(@role_menu_item)
    else
      respond_role_menu_item_with_error
    end
  end

  private

  def respond_role_menu_item_with_error
    return respond_with_error(@role_menu_item.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = @account.roles.find_by(id: params[:role_id])

    return respond_with_not_found unless @role
  end

  def set_role_menu_item
    @role_menu_item = @role.role_menu_items.find_by(id: params[:id])

    return respond_with_not_found unless @role_menu_item
  end

  # Only allow a list of trusted parameters through.
  def role_menu_item_params
    params.fetch(:role_menu_item, {}).permit(
      %i[menu_item_id]
    )
  end
end
