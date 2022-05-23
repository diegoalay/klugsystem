class User::Log < ApplicationRecord
  belongs_to :user, inverse_of: :logs
end
