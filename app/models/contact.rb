class Contact < ApplicationRecord
    include LoggerConcern

    validates :first_name, presence: true
    validates :first_surname, presence: true
end
