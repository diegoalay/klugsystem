module XmlServices
  include XmlServices::Helper
  require 'ox'

  class BillService
    def initialize(sale)
      @sale = sale
      @client = sale.client
      @account = sale.account
      @branch_office = sale.branch_office
    end

    def call
      io = (%{
        <dte:GTDocumento xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
          <dte:SAT ClaseDocumento="dte">
              <dte:DTE ID="DatosCertificados">
                  <dte:DatosEmision ID="DatosEmision">
                      <dte:DatosGenerales Tipo="FACT" FechaHoraEmision="#{date_format(@sale.created_at)}" CodigoMoneda="GTQ" />
                      <dte:Emisor NITEmisor="#{NITEMISOR}" NombreEmisor="#{NOMBREEMISOR}" CodigoEstablecimiento="#{@branch_office.legal_identifier}"
                          NombreComercial="#{@branch_office.legal_comercial_name}" AfiliacionIVA="#{@account.legal_membership}">
                          <dte:DireccionEmisor>
                              <dte:Direccion>#{branch_office.legal_direction}</dte:Direccion>
                              <dte:CodigoPostal>#{branch_office.legal_postcode}</dte:CodigoPostal>
                              <dte:Municipio>#{branch_office.legal_municipality}</dte:Municipio>
                              <dte:Departamento>#{branch_office.legal_department}</dte:Departamento>
                              <dte:Pais>GT</dte:Pais>
                          </dte:DireccionEmisor>
                      </dte:Emisor>
                      <dte:Receptor NombreReceptor="#{@client.billing_name}" IDReceptor="#{@client.billing_identifier}">
                          <dte:DireccionReceptor>
                            <dte:Direccion>#{@client.billing_address}</dte:Direccion>
                            <dte:CodigoPostal>#{@client.billing_postcode}</dte:CodigoPostal>
                            <dte:Municipio>#{@client.billing_municipality}</dte:Municipio>
                            <dte:Departamento>#{@client.billing_department}</dte:Departamento>
                            <dte:Pais>GT</dte:Pais>
                          </dte:DireccionReceptor>
                      </dte:Receptor>
                      <dte:Frases>
                        <dte:Frase TipoFrase="1" CodigoEscenario="1"/>
                      </dte:Frases>
                      <dte:Items>
                        #{generate_items}
                      </dte:Items>
                      <dte:Totales>
                          <dte:TotalImpuestos>
                              <dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="0.1071"/>
                          </dte:TotalImpuestos>
                          <dte:GranTotal>1.00</dte:GranTotal>
                      </dte:Totales>
                  </dte:DatosEmision>
              </dte:DTE>
          </dte:SAT>
        </dte:GTDocumento>
      })
    end

    def generate_items
      @sale.details.each_with_object([]) do |(sale_detail, index), items|
        items.push(%{
            <dte:Item NumeroLinea="#{each_with_object}" BienOServicio="B">
              <dte:Cantidad>#{sale_detail.quantity}</dte:Cantidad>
              <dte:UnidadMedida>#{sale_detail.measurement_unit.name}</dte:UnidadMedida>
              <dte:Descripcion>#{sale_detail.name}</dte:Descripcion>
              <dte:PrecioUnitario>#{sale_detail.price}</dte:PrecioUnitario>
              <dte:Precio>#{sale_detail.price}</dte:Precio>
              <dte:Descuento>#{sale_detail.discount_value}</dte:Descuento>
              <dte:Impuestos>
                  <dte:Impuesto>
                      <dte:NombreCorto>IVA</dte:NombreCorto>
                      <dte:CodigoUnidadGravable>1</dte:CodigoUnidadGravable>
                      <dte:MontoGravable>#{item_taxable_amount(item)}</dte:MontoGravable>
                      <dte:MontoImpuesto>#{item_tax_amount(item)}</dte:MontoImpuesto>
                  </dte:Impuesto>
              </dte:Impuestos>
              <dte:Total>#{sale_detail.total}</dte:Total>
          </dte:Item>
        })
      end
      .join(' ')
    end

    def item_tax_amount(item)fir
      item_taxable_amount(item) * 0.12
    end

    def item_taxable_amount(item)
      item.price / 1.12
    end
  end
end