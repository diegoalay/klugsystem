module XmlServices
  require 'ox'
  require 'stringio'

  class BillShared
    def initialize; end

    def call
      doc = Ox::Document.new

      instruct = Ox::Instruct.new(:xml)
      instruct[:version] = '1.0'
      instruct[:encoding] = 'UTF-8'
      doc << instruct

      top = Ox::Element.new('dte:GTDocumento')
      top['xmlns:xsi'] = 'http://www.w3.org/2001/XMLSchema-instance'
      top['Version'] = '0.1'
      doc << top

      mid = Ox::Element.new('dte:SAT')
      mid['ClaseDocumento'] = 'dte'
      doc << mid

      doc
    end
  end
end


# module XmlServices
#   require 'ox'
#   require 'stringio'

#   class BillService
#     def initialize(sale)
#       @sale = sale
#       @account = sale.account
#     end

#     def call
#       doc = XmlServices::BillShared.new.call

#       doc = general_details(doc)

#       xml = Ox.dump(doc)
#     end

#     def general_details(doc)

#     end
#   end
# end
