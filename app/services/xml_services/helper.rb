module XmlServices
  module Helper
    def date_format(date)
      date.strftime("%Y-%m-%dT%H:%M:%S")
    end
  end
end
