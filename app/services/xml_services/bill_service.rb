module XmlServices
  module BillService
    require 'ox'

    def generate_bill
      resp = certificate(generate_xml)
    end

    def generate_xml
      io = (%{
        <dte:GTDocumento xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
          <dte:SAT ClaseDocumento="dte">
              <dte:DTE ID="DatosCertificados">
                  <dte:DatosEmision ID="DatosEmision">
                      <dte:DatosGenerales Tipo="FACT" FechaHoraEmision="#{date_format(@sale.created_at)}" CodigoMoneda="GTQ" />
                      <dte:Emisor NITEmisor="#{@sale.account.billing_identifier}" NombreEmisor="#{@sale.account.billing_direction}" CodigoEstablecimiento="#{@sale.branch_office.billing_identifier}"
                          NombreComercial="#{@sale.account.billing_name}" AfiliacionIVA="#{@sale.account.billing_membership}">
                          <dte:DireccionEmisor>
                              <dte:Direccion>#{@sale.branch_office.billing_direction}</dte:Direccion>
                              <dte:CodigoPostal>#{@sale.branch_office.billing_postcode}</dte:CodigoPostal>
                              <dte:Municipio>#{@sale.branch_office.billing_municipality}</dte:Municipio>
                              <dte:Departamento>#{@sale.branch_office.billing_department}</dte:Departamento>
                              <dte:Pais>GT</dte:Pais>
                          </dte:DireccionEmisor>
                      </dte:Emisor>
                      <dte:Receptor NombreReceptor="#{@sale.client.billing_name}" IDReceptor="#{@sale.client.billing_identifier}">
                          <dte:DireccionReceptor>
                            <dte:Direccion>#{@sale.client.billing_address}</dte:Direccion>
                            <dte:CodigoPostal>#{client_billing_postcode}</dte:CodigoPostal>
                            <dte:Municipio>#{client_billing_municipality}</dte:Municipio>
                            <dte:Departamento>#{client_billing_department}</dte:Departamento>
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
  end
end