class Provider::ContactsController < ApplicationController
  before_action :set_contact, only: %i[update destroy]
  before_action :set_provider, only: %i[index create]

  # GET /contacts or /contacts.json
  def index
    respond_to do |format|
      format.html {}
      format.json do

        respond_with_successful(Product::Contact.index(@account, @provider, @query))
      end
    end
  end

  # POST /contacts or /contacts.json
  def create
    @contact = @provider.contacts.new(contact_params)
    @contact.user_creator = current_user

    if @contact.save
      respond_with_successful(@contact)
    else
      respond_contact_with_error
    end
  end

  # PATCH/PUT /contacts/1 or /contacts/1.json
  def update
    @provider.user_modifier = current_user

    if @provider.update(contact_params)
      respond_with_successful(@provider)
    else
      respond_provider_with_error
    end
  end

  # DELETE /providers/1 or /providers/1.json
  def destroy
    @contact.user_modifier = current_user

    if @contact.destroy
      respond_with_successful(@contact)
    else
      respond_provider_with_error
    end
  end

  private

  def respond_contact_with_error
    return respond_with_error(@contact.errors.full_messages.to_sentence)
  end

  def set_provider
    @provider = @account.providers.find_by(id: params[:provider_id])
  end

  def set_contact
    set_provider

    @contact = @provider.contacts.find_by(id: params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contact_params
    params.fetch(:contact, {}).permit(
      %i[quantity contact_type_id description category]
    )
  end
end
