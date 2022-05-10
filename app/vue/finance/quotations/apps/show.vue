<script>
export default {
    props: {},

    mounted(){
        this.setId()
        this.getData()
    },

    data(){
        return {
            quotation: {
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
                label: 'Descuento (Q.)',
                key: 'discount_value'
            },{
                label: 'Cantidad',
                key: 'quantity'
            },{
                label: 'Total',
                key: 'subtotal',
                thClass: 'text-right',
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

        getData(){
            const url = this.url.finance('quotations/:id', {id: this.id})
            this.http.get(url).then(result => {
                if (result.successful) {
                    for (let key in result.data) {
                        this[key] = result.data[key]
                    }

                    if (this.quotation) {
                        this.totals = [
                            {
                                description: 'Subtotal',
                                value: this.quotation.subtotal
                            },{
                                description: 'Descuento',
                                value: this.quotation.discount
                            },{
                                description: 'Total (- Descuento)',
                                value: this.quotation.subtotal1
                            },{
                                description: 'Interés',
                                value: this.quotation.interest
                            },{
                                description: 'Total (+ Intéres)',
                                value: this.quotation.subtotal2
                            },{
                                description: 'Envío',
                                value: this.quotation.shipping_costs
                            },{
                                description: 'Total',
                                value: this.quotation.total
                            }
                        ]
                    }
                }else{
                    this.$toast.error(result.error.message)
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
            title="Cotización">
            <slot name="buttons">
                <b-button variant="outline-dark" to="/finance/quotations/new" class="mb-2">
                    Cotizar <font-awesome-icon icon="cart-shopping" />
                </b-button>

                <b-button variant="outline-dark" class="mb-2" to="/finance/quotations">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </slot>
        </component-header-form>
        <b-row class="justify-content-md-center">
            <b-col md="10" sm="12">
                <b-card>
                    <div class="bg-primary total-header text-center">
                        Cotización - {{ quotation.total ? 'Q ' + quotation.total : '' }}
                    </div>
                    <br>

                    <b-row>
                        <b-col md="4" sm="12">
                            <h5> <b>  Datos generales </b> </h5>
                            <b> Fecha: </b> {{ quotation.quotation_date }} <br>
                            <b> Método de pago: </b> {{ payment_method.name }} <br>
                        </b-col>

                        <b-col md="4">
                            <h5> <b>  Detalles de factura </b> </h5>
                            <b> Cantidad recibida: </b> {{ quotation.received_amount }} <br>
                            <b> Vuelto: </b> {{ quotation.change }} <br>
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

                    <hr>
                    <div class="text-right">
                        <b-button variant="primary" @click="tools.printQuotation(quotation.id)">
                            <font-awesome-icon icon="print"/> Imprimir
                        </b-button>
                    </div>
                </b-card>
            </b-col>
        </b-row>
    </section>
</template>