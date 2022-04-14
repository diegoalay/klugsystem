module XmlServices
  require 'ox'

  class BillService
    def initialize(sale)
      @sale = sale
      @account = sale.account
    end

    def call
      io = (%{
        <dte:GTDocumento xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xmlns:dte="http://www.sat.gob.gt/dte/fel/0.2.0" Version="0.1">
          <dte:SAT ClaseDocumento="dte">
              <dte:DTE ID="DatosCertificados">
                  <dte:DatosEmision ID="DatosEmision">
                      <dte:DatosGenerales Tipo="FACT" FechaHoraEmision="#{HORA}" CodigoMoneda="GTQ" />
                      <dte:Emisor NITEmisor="#{NITEMISOR}" NombreEmisor="#{NOMBREEMISOR}" CodigoEstablecimiento="#{CODIGOESTABLECIMIENTO}"
                          NombreComercial="#{NOMBRECOMERCIALESTABLECIMIENTO}" AfiliacionIVA="#{AFILIACIONIBA}">
                          <dte:DireccionEmisor>
                              <dte:Direccion>#{EMISORDIRECCION}</dte:Direccion>
                              <dte:CodigoPostal>#{CODIGOPOSTAL}</dte:CodigoPostal>
                              <dte:Municipio>#{MUNICIPIO}</dte:Municipio>
                              <dte:Departamento>#{DEPARTAMENTO}</dte:Departamento>
                              <dte:Pais>#{PAIS}</dte:Pais>
                          </dte:DireccionEmisor>
                      </dte:Emisor>
                      <dte:Receptor NombreReceptor="#{NOMBRERECEPTOR}" IDReceptor="#{NITRECEPTOR}">
                          <dte:DireccionReceptor>
                              <dte:Direccion>#{DIRECCIONRECEPTOR}</dte:Direccion>
                              <dte:CodigoPostal>#{POSTALRECEPTOR}</dte:CodigoPostal>
                              <dte:Municipio>#{MUNICIPIORECEPTOR}</dte:Municipio>
                              <dte:Departamento>#{DEPARTAMENTORECEPTOR}</dte:Departamento>
                              <dte:Pais>#{PAIS}</dte:Pais>
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
              <dte:Adenda>
              <dtecomm:Informacion_COMERCIAL xmlns:dtecomm="https://www.digifact.com.gt/dtecomm" xsi:schemaLocation="https://www.digifact.com.gt/dtecomm">
                <dtecomm:InformacionAdicional Version="7.1234654163">
                    <dtecomm:REFERENCIA_INTERNA>1B7IUMWYO3B2</dtecomm:REFERENCIA_INTERNA>
                    <dtecomm:FECHA_REFERENCIA>2021-08-15T10:40:00</dtecomm:FECHA_REFERENCIA>
                    <dtecomm:VALIDAR_REFERENCIA_INTERNA>VALIDAR</dtecomm:VALIDAR_REFERENCIA_INTERNA>
                  </dtecomm:InformacionAdicional>
                  </dtecomm:Informacion_COMERCIAL>
              </dte:Adenda>
          </dte:SAT>
        </dte:GTDocumento>
      })
    end

    def generate_items
      @sale.details.each_with_object([]) do |(sale_detail, index), items|
        items.push(
          %{
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
                      <dte:MontoGravable>0.89</dte:MontoGravable>
                      <dte:MontoImpuesto>0.1071</dte:MontoImpuesto>
                  </dte:Impuesto>
              </dte:Impuestos>
              <dte:Total>#{sale_detail.total}</dte:Total>
          </dte:Item>
        }
        )
      end
    end
  end
end