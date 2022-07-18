module XmlServices
  class BillCertificationService
    include XmlServices::Helper

    require 'ox'

    def initialize sale
      @sale = sale
      @total_taxes_amount = 0
      @total = 0
    end

    def call
      generate_xml

      # DATA data = Base64.decode64(Sale::ElectronicBill.last.certification_data['ResponseDATA1'])
      # IMPUESTOS ITEM Ox.load(data, mode: :hash)[:"dte:GTDocumento"][1][:"dte:SAT"][1][:"dte:DTE"][1][:"dte:DatosEmision"][5][:"dte:Items"]
      # TOTAL IMPUESTOS
      # NOMBRE IMPUESTO Ox.load(data, mode: :hash)[:"dte:GTDocumento"][1][:"dte:SAT"][1][:"dte:DTE"][1][:"dte:DatosEmision"][6][:"dte:Totales"][:"dte:TotalImpuestos"][:"dte:TotalImpuesto"][0][:NombreCorto]
      # VALOR Ox.load(data, mode: :hash)[:"dte:GTDocumento"][1][:"dte:SAT"][1][:"dte:DTE"][1][:"dte:DatosEmision"][6][:"dte:Totales"][:"dte:TotalImpuestos"][:"dte:TotalImpuesto"][0][:TotalMontoImpuesto]
      # GRAN TOTAL Ox.load(data, mode: :hash)[:"dte:GTDocumento"][1][:"dte:SAT"][1][:"dte:DTE"][1][:"dte:DatosEmision"][6][:"dte:Totales"][:"dte:GranTotal"]
    end

    def generate_xml
      io = (%{
        <dte:GTDocumento xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
          <dte:SAT ClaseDocumento="dte">
              <dte:DTE ID="DatosCertificados">
                  <dte:DatosEmision ID="DatosEmision">
                      <dte:DatosGenerales Tipo="FACT" FechaHoraEmision="#{date_format(@sale.sale_date)}" CodigoMoneda="GTQ" />
                      <dte:Emisor NITEmisor="#{@sale.account.billing_identifier}" NombreEmisor="#{@sale.account.billing_name}" CodigoEstablecimiento="#{@sale.branch_office.billing_identifier}"
                          NombreComercial="#{@sale.account.name}" AfiliacionIVA="GEN">
                          <dte:DireccionEmisor>
                              <dte:Direccion>#{@sale.account.billing_address}</dte:Direccion>
                              <dte:CodigoPostal>#{account_billing_postcode}</dte:CodigoPostal>
                              <dte:Municipio>#{account_billing_municipality||''}</dte:Municipio>
                              <dte:Departamento>#{account_billing_department||''}</dte:Departamento>
                              <dte:Pais>GT</dte:Pais>
                          </dte:DireccionEmisor>
                      </dte:Emisor>
                      <dte:Receptor NombreReceptor="#{@sale.client.billing_name}" IDReceptor="#{@sale.client.billing_identifier}" CorreoReceptor="#{@sale.client.billing_email}">
                          <dte:DireccionReceptor>
                            <dte:Direccion>#{@sale.client.billing_address}</dte:Direccion>
                            <dte:CodigoPostal>#{client_billing_postcode}</dte:CodigoPostal>
                            <dte:Municipio>#{client_billing_municipality}</dte:Municipio>
                            <dte:Departamento>#{client_billing_department}</dte:Departamento>
                            <dte:Pais>GT</dte:Pais>
                          </dte:DireccionReceptor>
                      </dte:Receptor>
                      <dte:Frases>
                        <dte:Frase TipoFrase="#{@sale.account.billing_phrase}" CodigoEscenario="#{@sale.account.billing_stage}"/>
                      </dte:Frases>
                      <dte:Items>
                        #{generate_items}
                      </dte:Items>
                      <dte:Totales>
                          <dte:TotalImpuestos>
                              <dte:TotalImpuesto NombreCorto="IVA" TotalMontoImpuesto="#{@total_taxes_amount}"/>
                          </dte:TotalImpuestos>
                          <dte:GranTotal>#{@total}</dte:GranTotal>
                      </dte:Totales>
                  </dte:DatosEmision>
              </dte:DTE>
          </dte:SAT>
        </dte:GTDocumento>
      })
    end

    def generate_items
      index = 1
      @sale.details.each_with_object([]) do |(sale_detail), items|
        price = round(item_price(sale_detail))
        taxable_amount = round(item_taxable_amount(sale_detail))
        taxes_amount = round(item_tax_amount(sale_detail))
        total = round(sale_detail.total)

        items.push(%{
            <dte:Item NumeroLinea="#{index}" BienOServicio="#{item_product_type(sale_detail)}">
              <dte:Cantidad>#{sale_detail.quantity}</dte:Cantidad>
              <dte:UnidadMedida>#{item_measurement_unit(sale_detail)}</dte:UnidadMedida>
              <dte:Descripcion>#{sale_detail.name}</dte:Descripcion>
              <dte:PrecioUnitario>#{price}</dte:PrecioUnitario>
              <dte:Precio>#{round(sale_detail.final_subtotal)}</dte:Precio>
              <dte:Descuento>#{round(sale_detail.discount_value)}</dte:Descuento>
              <dte:Impuestos>
                  <dte:Impuesto>
                      <dte:NombreCorto>IVA</dte:NombreCorto>
                      <dte:CodigoUnidadGravable>1</dte:CodigoUnidadGravable>
                      <dte:MontoGravable>#{taxable_amount}</dte:MontoGravable>
                      <dte:MontoImpuesto>#{taxes_amount}</dte:MontoImpuesto>
                  </dte:Impuesto>
              </dte:Impuestos>
              <dte:Total>#{total}</dte:Total>
          </dte:Item>
        })

        @total_taxes_amount += taxes_amount
        @total += total
      end
      .join(' ')
    end
  end
end