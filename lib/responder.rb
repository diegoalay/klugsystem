class Responder 
  def self.pagination(data, records = nil)
    records = data if records.nil?

    {
      current_page: data.current_page,
      total_pages: data.total_pages,
      total_count: data.total_count,
      total_lenght: data.length,
      records: records
    }
  end
end