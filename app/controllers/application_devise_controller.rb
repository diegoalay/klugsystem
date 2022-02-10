class ApplicationDeviseController < ApplicationController
  before_action :set_data

  def set_data
    @data = {
      url: {
        root: request.base_url.to_s,  path: request.path
      }
    }
  end
end