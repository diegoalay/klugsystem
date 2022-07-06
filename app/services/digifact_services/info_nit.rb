module DigifactServices
  module InfoNit
    def info_nit(billing_identifier)
      resp = info_billing_identifier(billing_identifier)

      if (resp.code.eql?(200) && resp.parsed_response['RESPONSE'][0].present?)
        return {
          billing_department: resp.parsed_response['RESPONSE'][0]['DEPARTAMENTO'],
          billing_address: resp.parsed_response['RESPONSE'][0]['Direccion'],
          billing_municipality: resp.parsed_response['RESPONSE'][0]['MUNICIPIO'],
          billing_identifier: resp.parsed_response['RESPONSE'][0]['NIT'],
          billing_name: generate_client_name(resp.parsed_response['RESPONSE'][0]['NOMBRE']),
          country: resp.parsed_response['RESPONSE'][0]['PAIS']
        }
      else
        return {
          name: nil
        }
      end
    end

    private

    def generate_client_name(name)
      name = name.split(',')

      first_name = name[3]&.squish
      second_name = name[4]&.squish

      first_surname = name[0]&.squish
      second_surname = name[1]&.squish
      third_surname = name[2]&.squish

      [first_name, second_name, first_surname, second_surname, third_surname].compact.join(' ')
    end
  end
end