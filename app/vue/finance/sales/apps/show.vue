<script>
export default {
    props: {},

    mounted(){
        this.setId()
        this.getData()
    },

    data(){
        return {
            sale: {
                id: null
            },
            client: {
                id: null
            },
            payment_method: {
                id: null,
            },
            employee: {
                id: null,
            },
            fields: [{
                label: 'Artículo',
                key: 'name'
            },{
                label: 'Precio',
                key: 'price'
            },{
                label: 'Descuento (%)',
                key: 'discount_percentage'
            },{
                label: 'Descuento (Q.)',
                key: 'discount_value'
            },{
                label: 'Cantidad',
                key: 'quantity'
            },{
                label: 'Total',
                key: 'subtotal',
                tdClass: 'text-right',
            }],
            details: [],
            totalField: [
                {
                    key: 'description',
                    tdClass: 'text-left font-weight-bold',
                },
                {
                    key: 'value',
                    tdClass: 'text-right',
                }
            ],
            totals: []
        }
    },

    methods:{
        setId(){
            this.id = this.$route.params.id
        },

        getSubtotal1(){
            return parseFloat(this.sale.subtotal) - parseFloat(this.sale.discount)
        },

        getSubtotal2(){
            return this.getSubtotal1() + parseFloat(this.sale.interest)
        },

        getData(){
            const url = this.url.finance('sales/:id', {id: this.id})
            this.http.get(url).then(result => {
                if (result.successful) {
                    for (let key in result.data) {
                        this[key] = result.data[key]
                    }

                    if (this.sale) {
                        this.totals = [
                            {
                                description: 'Subtotal',
                                value: this.sale.subtotal
                            },{
                                description: 'Descuento',
                                value: this.sale.discount
                            },{
                                description: 'Total (- Descuento)',
                                value: this.getSubtotal1()
                            },{
                                description: 'Interés',
                                value: this.sale.interest
                            },{
                                description: 'Total (+ Intéres)',
                                value: this.getSubtotal2()
                            },{
                                description: 'Envío',
                                value: this.sale.shipping_costs
                            },{
                                description: 'Total',
                                value: this.sale.total
                            }
                        ]
                    }
                }else{
                    alert(response.erros.message)
                }
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>
<template lang="">
    <section class="application-componeent">
        <component-header-form
            title="Ventas">
            <slot name="buttons">
                <b-button variant="outline-dark" to="/finance/sales/new" class="mb-2">
                    Vender <font-awesome-icon icon="cart-shopping" />
                </b-button>

                <b-button variant="outline-dark" class="mb-2" to="/finance/sales">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </slot>
        </component-header-form>
        <b-container>
            <b-row class="justify-content-md-center">
                <b-col md="10" sm="12">
                    <b-card>
                        <div class="bg-primary total-header text-center">
                            {{ sale.total ? 'Q ' + sale.total : '' }}
                        </div>
                        <br>

                        <b-row>
                            <b-col md="4" sm="12">
                                <h5> <b>  Datos generales </b> </h5>
                                <b> Fecha: </b> {{ sale.sale_date }} <br>
                                <b> Tipo de venta: </b> {{ sale.sale_type }} <br>
                                <b> Método de pago: </b> {{ payment_method.name }} <br>
                            </b-col>

                            <b-col md="4">
                                <h5> <b>  Detalles de factura </b> </h5>
                                <b> Cantidad recibida: </b> {{ sale.received_amount }} <br>
                                <b> Vuelto: </b> {{ sale.change }} <br>
                            </b-col>

                            <b-col md="4" sm="12">
                                <h5> <b>  Datos de cliente </b> </h5>
                                <b> Nit: </b> {{ client.billing_identifier }} <br>
                                <b> Nombre: </b> {{ client.billing_name }} <br>
                                <b> Dirección: </b> {{ client.billing_address }} <br>
                                <b> E-Mail: </b> {{ client.billing_email }} <br>
                            </b-col>
                        </b-row>

                        <br>
                        <b-table
                            responsive
                            :fields="fields"
                            :items="details"
                        >
                        </b-table>

                        <br>
                        <b-row class="justify-content-end">
                            <b-col md="6" sm="12">
                                <b-table
                                    :fields="totalField"
                                    :items="totals"
                                    thead-class="d-none">
                                </b-table>
                            </b-col>
                        </b-row>
                    </b-card>
                </b-col>
            </b-row>
        </b-container>
    </section>
</template>