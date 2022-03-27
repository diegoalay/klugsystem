class EventQuery
  def initialize(account)
    @events = account.events
  end
end