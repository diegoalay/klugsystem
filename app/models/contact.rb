class Contact < ApplicationRecord
    include LoggerConcern

    validates :first_name, presence: true
    validates :first_surname, presence: true

    has_many :events

    acts_as_paranoid

    def identifier
        full_name
    end

    def full_name
        [first_name, first_surname].join(" ")
    end

    def show
        attributes.merge(full_name: full_name)
    end
end
