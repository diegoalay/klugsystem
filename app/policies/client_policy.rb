class ClientPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def index?
    @user.can?('crm.clients')
  end

  alias edit? index?
  alias show? index?
  alias new? index?
end