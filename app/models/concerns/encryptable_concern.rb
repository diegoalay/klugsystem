require 'openssl'

module EncryptableConcern
  extend ActiveSupport::Concern

  class_methods do
    def encryptable_json_fields(json_field, *fields)
      fields.each do |field|
        define_method(field) do
          return '' unless (iv_field = send(json_field)&.dig("#{field}_iv")) &&
              (val = send(json_field)&.dig(field))
          cipher = generate_decryption_cipher(iv_field)
          decrypted_data = cipher.update(Base64.decode64(val))
          decrypted_data << cipher.final
        end

        define_method("#{field}=") do |val|
          json = send(json_field) || {}
          if val.nil?
            json["#{field}_iv"] = nil
            json[field] = nil
          else
            encrypted_data, cipher_iv = encrypt(val)

            json["#{field}_iv"] = Base64.encode64(cipher_iv)
            json[field] = Base64.encode64(encrypted_data)
          end

          send("#{json_field}=", json)
        end
      end
    end
  end

  included do
    def encrypt(data)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.encrypt
      cipher.key = Base64.decode64(Rails.application.credentials[:keys][:cypher])

      iv = cipher.random_iv
      encrypted_data = cipher.update(data)
      encrypted_data << cipher.final

      [encrypted_data, iv]
    end

    def generate_decryption_cipher(iv)
      cipher = OpenSSL::Cipher::AES256.new(:CBC)
      cipher.decrypt
      cipher.key = Base64.decode64(Rails.application.credentials[:keys][:cypher])

      cipher.iv = Base64.decode64(iv)
      cipher
    end
  end
end