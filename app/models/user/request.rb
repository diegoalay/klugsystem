class User::Request < ApplicationRecord
  include EncryptableConcern

  encryptable_json_fields(:params, 'params_attributes')

  belongs_to :user, inverse_of: :requests

  store_accessor :params, :params_attributes
end
