class ContactsController < ApplicationSystemController
  before_action :set_client, only: %i[update destroy]

  # GET /contacts or /contacts.json
  def index
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(Crm::ContactQuery.new(@account).index)
      end
    end
  end

  # GET /contacts/1 or /contacts/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_client

        respond_with_successful(@contact.show)
      end
    end
  end

  # GET /contacts/new
  def new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts or /contacts.json
  def create
    @contact = @account.contacts.new(client_params)
    @contact.user_creator = current_user
    @contact.user_modifier = current_user

    if @contact.save
      respond_with_successful(@contact)
    else
      respond_client_with_error
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    @contact.user_modifier = current_user

    if @contact.update(client_params)
      respond_with_successful(@contact.show)
    else
      respond_client_with_error
    end
  end

  # DELETE /contacts/1 or /contacts/1.json
  def destroy
    @contact.user_modifier = current_user

    if @contact.destroy
      respond_with_successful(@contact)
    else
      respond_client_with_error
    end
  end

  def search
    respond_with_successful(Crm::ContactQuery.new(@account).search(@query))
  end

  private

  def respond_client_with_error
    return respond_with_error(@contact.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @contact = @account.contacts.find_by(id: params[:id])

    return respond_with_not_found unless @contact
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.fetch(:contact, {}).permit(
      %i[first_name first_surname  second_name second_surname gender birthdate title
        mobile_number telephone fax email note
      ]
    )
  end
end