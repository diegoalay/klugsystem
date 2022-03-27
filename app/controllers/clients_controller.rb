class ClientsController < ApplicationSystemController
  before_action :set_client, only: %i[update destroy]

  # GET /clients or /clients.json
  def index
    respond_to do |format|
      format.html {}
      format.json do
        respond_with_successful(Crm::ClientQuery.new(@account).index)
      end
    end
  end

  # GET /clients/1 or /clients/1.json
  def show
    respond_to do |format|
      format.html {}
      format.json do
        set_client

        respond_with_successful(@client)
      end
    end
  end

  # GET /clients/new
  def new
  end

  # GET /clients/1/edit
  def edit
  end

  # POST /clients or /clients.json
  def create
    @client = @account.clients.new(client_params)
    @client.user_creator = current_user
    @client.user_modifier = current_user

    if @client.save
      respond_with_successful(@client)
    else
      respond_client_with_error
    end
  end

  # PATCH/PUT /clients/1 or /clients/1.json
  def update
    @client.user_modifier = current_user

    if @client.update(client_params)
      respond_with_successful(@client)
    else
      respond_client_with_error
    end
  end

  # DELETE /clients/1 or /clients/1.json
  def destroy
    @client.user_modifier = current_user

    if @client.destroy
      respond_with_successful(@client)
    else
      respond_client_with_error
    end
  end

  def search
    respond_with_successful(Crm::ClientQuery.new(@account).search(@query))
  end

  def export_csv
    contact_template = IO.binread("#{Rails.root}/storage/templates/vcard/contact.vcf")

    main_department = self.company.main_department

    contact_template = contact_template
    .gsub("{{contact_first_name}}", ( self.first_name || "").strip )
    .gsub("{{contact_first_surname}}", ( self.first_surname || "").strip )
    .gsub("{{contact_email}}", ( self.email || "").strip )
    .gsub("{{contact_telephone}}", ( self.telephone || "").strip )
    .gsub("{{contact_fax}}", ( self.company.fax || "").strip )
    .gsub("{{contact_title}}", ( self.title || "").strip )
    .gsub("{{contact_birthdate}}", ( self.birthdate.blank? ? "" : self.birthdate.strftime("%Y%m%d")) )

    contact_template
  end

  private

  def respond_client_with_error
    return respond_with_error(@client.errors.full_messages.to_sentence)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = @account.clients.find_by(id: params[:id])

    return respond_with_not_found unless @client
  end

  # Only allow a list of trusted parameters through.
  def client_params
    params.fetch(:client, {}).permit(
      %i[first_name first_surname  gender birthdate title
        mobile_number telephone fax email note
        billing_name billing_address billing_identifier billing_email
      ]
    )
  end
end