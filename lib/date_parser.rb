class DateParser

  def self.timeify(timestamp)
    DateTime.iso8601 timestamp if timestamp
  end
end