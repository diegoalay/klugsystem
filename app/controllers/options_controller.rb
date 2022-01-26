class OptionsController < ApplicationSystemController

    def fetch_current_user
        return current_user
    end

    def api_destinations
        destinations = Destination.all #.map{|k, _| {value: k.id, text: k.name }}
        responseWithSuccess(destinations)
    end

    def api_expeditures
        expeditures = Expediture.where(:companies_id => current_user.company.id)
        responseWithSuccess(expeditures)
    end

end
