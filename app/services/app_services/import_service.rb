
module AppServices
  class ImportService
    def initialize
      @files = Dir.glob(Rails.root.join('db', 'imports', 'kaminal', '**')).sort
    end

    def call
      @files.each do |file_path|
        class_name = file_path.split('/').last.gsub('.json', '')
        class_name = class_name.singularize

        if File.exists?(file_path)
          file = File.open(file_path)
          data = file.read
          file.close

          file_data = JSON.parse(data)
        end

        file_data.each do |data|
          case class_name
          when "account"
            create_account(data)
          when "product"
            create_product(data)
          when "branch_office"
            create_branch_office(data)
          when "contact"
            create_contact(data)
          when "payment_method"
            create_payment_method(data)
          when "user"
            create_user(data)
          else
            create_object(data["name"], class_name)
          end
        end
      end
    end

    def create_account(data)
      @account = Account.find_or_create_by(name: data["name"])
    end

    def create_product(data)
      product = @account.products.find_or_initialize_by(
        name: data["name"],
        quantity: data["quantity"],
        measurement_unit: create_object(data["measurement_unit"], "measurement_unit"),
        branch_office: @account.branch_offices.first,
        retail_price: data["retail_price"],
        wholesale_price: data["wholesale_price"],
        brand: create_object(data["brand"], "brand"),
        department: create_object(data["department"], "department")
      )

      product.save!
    end

    def create_branch_office(data)
      branch_office = @account.branch_offices.find_or_initialize_by(name: data["name"])
      branch_office.assign_attributes(
        telephone: data["telephone"],
        postcode: data["postcode"],
        street_address: data["street_address"],
        street_name: data["street_name"],
        street_number: data["street_number"],
        electronic_billing: data["electronic_billing"],
        billing_address: data["billing_address"],
        billing_postcode: data["billing_postcode"],
        billing_address: data["billing_address"],
        billing_municipality: data["billing_municipality"],
        billing_department: data["billing_department"]
      )

      branch_office.save!
      branch_office
    end

    def create_contact(data)
      contact = @account.contacts.find_or_initialize_by(
        first_name: data["first_name"],
        first_surname: data["first_surname"]
      )

      contact.assign_attributes(
        second_name: data["second_name"],
        second_surname: data["second_surname"],
        mobile_number: data["mobile_number"],
        email: data["email"],
        birthdate: data["birthdate"],
        note: data["note"]
      )

      contact.save!
    end

    def create_payment_method(data)
      payment_method = @account.payment_methods.find_or_initialize_by(
        name: data["name"].downcase
      )

      if (payment_method.id.nil?)
        payment_method.assign_attributes(
          interest_percentage: data["interest_percentage"],
          category: data["category"]
        )

        payment_method.save!
      end

      payment_method
    end

    def create_user(data)
      user = @account.users.find_or_initialize_by(
        email: data["email"]
      )

      user.assign_attributes(
        first_name: data["first_name"],
        first_surname: data["first_surname"],
        username: data["username"],
        branch_office: @account.branch_offices.first
      )

      user.password = @account.name.gsub(" ", "_").downcase + "$2022"
      if (user.save!)
        user.user_roles.find_or_create_by(role_id: @account.roles.first.id)
      end
      user
    end

    def create_object(name, class_name)
      return nil if name.blank?

      class_instance = class_name.classify
      class_instance.constantize.find_or_create_by(
        name: name,
        account: @account
      )
    end
  end
end