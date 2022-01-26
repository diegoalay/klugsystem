class RootController < ApplicationSystemController
  def home
    respond_to do |format|
        format.html {}
    end
  end
end
