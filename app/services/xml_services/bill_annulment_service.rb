module XmlServices
  class BillAnnulmentService
    include XmlServices::Helper

    require 'ox'

    def initialize sale
      @sale = sale
    end

    def call
      generate_xml
    end

    def generate_xml
      io = (%{
        <dte:GTAnulacionDocumento xmlns:dte="http://www.sat.gob.gt/dte/fel/0.1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" Version="0.1">
          <dte:SAT>
            <dte:AnulacionDTE ID="DatosCertificados">
            <dte:DatosGenerales ID="DatosAnulacion"
              NumeroDocumentoAAnular="#{@sale.electronic_bill.identifier}"
              NITEmisor="#{@sale.account.billing_identifier}"
              IDReceptor="#{@sale.client.billing_identifier}"
              FechaEmisionDocumentoAnular="#{date_format(@sale.sale_date)}"
              FechaHoraAnulacion="#{date_format(Time.current)}"
              MotivoAnulacion="ELIMINACION"/>
            </dte:AnulacionDTE>
          </dte:SAT>
        </dte:GTAnulacionDocumento>
      })
    end
  end
end