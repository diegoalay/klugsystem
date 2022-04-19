class UsersController < ApplicationSystemController
  def search
    respond_with_successful(User.search(@account, @query))
  end
end