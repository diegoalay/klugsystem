class DateParser

  def self.timeify(timestamp)
    DateTime.iso8601 timestamp if timestamp
  end

  def self.datetime(timestamp = nil)
    zone = ActiveSupport::TimeZone.new('America/Guatemala')

    return timestamp.in_time_zone(zone) if timestamp

    return Time.current.in_time_zone(zone)
  end

  def self.datetime_string(timestamp, format = "%d-%m-%Y %H:%M")
    self.datetime(timestamp).strftime(format)
  end
end