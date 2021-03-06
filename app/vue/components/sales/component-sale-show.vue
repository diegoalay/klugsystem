<script>
export default {
    props: {
        app_module: {
            required: true,
            type: String
        },
        controller: {
            required: true,
            type: String
        }
    },

    mounted(){
        this.setId()
        this.getData()
    },

    data(){
        return {
            sale: {
                id: null,
                status: true
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
                label: 'Unidad',
                key: 'measurement_unit'
            },{
                label: 'Precio',
                key: 'price'
            },{
                label: 'Interés',
                key: 'interest_value'
            },{
                label: 'Descuento',
                key: 'discount_value'
            },{
                label: 'Cantidad',
                key: 'quantity'
            },{
                label: 'Total',
                key: 'total',
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
            totals: [],
            options: {
                billing_fields: []
            },
            loading_options: false,
            custom_fields: []
        }
    },

    methods:{
        setId(){
            this.id = this.$route.params.id
        },

        putForm(){
            const url = this.url[this.app_module](`${this.controller}/:id`, {id: this.id})
            let form = {
                sale: {
                    custom_fields: this.custom_fields.map(e => {
                        return {
                            id: e.id,
                            value: e.value,
                            title: e.title,
                            label: e.label,
                            visible: e.visible
                        }
                    })
                }
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Campos de facturación guardados exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        billingFieldsEmpty(){
            if (this.custom_fields.length > 0) return false
            return true
        },

        getOptions(){
            const url = this.url[this.app_module](`${this.controller}/options`)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    this.custom_fields = JSON.parse(JSON.stringify(this.options.billing_fields||[]))
                    for(let key in this.custom_fields) {
                        const custom_field = this.custom_fields[key]

                        let value = custom_field.value

                        const find = (this.sale.custom_fields||[]).find(e => e.id === custom_field.id)
                        if (find && find.value) {
                            this.custom_fields[key].value = find.value
                        }
                    }

                    this.loading_options = true
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getData(){
            const url = this.url[this.app_module](`${this.controller}/:id`, {id: this.id})
            this.http.get(url).then(result => {
                if (result.successful) {
                    for (let key in result.data) {
                        this[key == 'quotation' ? 'sale' : key] = result.data[key]
                    }

                    if (this.sale) {
                        this.totals = [
                            {
                                description: 'Subtotal',
                                value: this.sale.subtotal
                            },{
                                description: 'Interés',
                                value: this.sale.interest
                            },{
                                description: 'Total (+ Intéres)',
                                value: this.sale.subtotal1
                            },{
                                description: 'Descuento',
                                value: this.sale.discount
                            },{
                                description: 'Total (- Descuento)',
                                value: this.sale.subtotal2
                            },{
                                description: 'Envío',
                                value: this.sale.shipping_costs
                            },{
                                description: 'Total',
                                value: this.sale.total
                            }
                        ]
                    }

                    this.getOptions()
                }else{
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        textAreaComponent(obj){
            if (!obj) return 0
            if (!obj['value']) return 0

            return obj['value'].length > 50
        },

        isElectronicBill(){
            return (this.sale?.sale_type === 'electronic_bill')
        },

        sendToClipboard(string) {
            const el = document.createElement('textarea');
            el.value = string
            el.setAttribute('readonly', '');
            el.style.position = 'absolute';
            el.style.left = '-9999px';
            document.body.appendChild(el);
            el.select();
            document.execCommand('copy');
            document.body.removeChild(el);

            this.$toast.success('Texto copiado al portapapeles')
        },

        printDocument(){
            if (this.controller === 'quotations') {
                this.tools.printQuotation(this.sale.id)
            } else {
                this.tools.printSale(this.sale)
            }
        }
    }
}
</script>
<template>
    <section>
        <component-header-form
            title="Ventas">
            <slot name="buttons">
                <b-button variant="outline-dark" :to="`/${app_module}/${controller}/new`" class="mb-2">
                    Vender <font-awesome-icon icon="cart-shopping" />
                </b-button>

                <b-button variant="outline-dark" class="mb-2" :to="`/${app_module}/${controller}`">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </slot>
        </component-header-form>
        <b-row :class="!isElectronicBill() ? 'justify-content-md-center' : ''" v-if="loading_options">
            <b-col v-if="isElectronicBill()">
                <b-card>
                    <template #header>
                        <h5 class="mb-0 font-weight-bold">Información de facturación electrónica</h5>
                    </template>

                    <b-form-group>
                        <template #label>
                            {{ 'Serie' }}
                        </template>

                        <b-input-group>
                            <b-form-input
                                readonly
                                :value="electronic_bill.serie"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                            <b-input-group-prepend>
                                <button @click="sendToClipboard(electronic_bill.serie)">
                                    <font-awesome-icon icon="copy" />
                                </button>
                            </b-input-group-prepend>
                        </b-input-group>
                    </b-form-group>

                    <b-form-group>
                        <template #label>
                            {{ 'Número' }}
                        </template>

                        <b-input-group>
                            <b-form-input
                                readonly
                                :value="electronic_bill.number"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                            <b-input-group-prepend>
                                <button @click="sendToClipboard(electronic_bill.number)">
                                    <font-awesome-icon icon="copy" />
                                </button>
                            </b-input-group-prepend>
                        </b-input-group>
                    </b-form-group>

                    <b-form-group>
                        <template #label>
                            {{ 'N0. Autorización' }}
                        </template>

                        <b-input-group>
                            <b-form-input
                                readonly
                                :value="electronic_bill.identifier"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                            <b-input-group-prepend>
                                <button @click="sendToClipboard(electronic_bill.identifier)">
                                    <font-awesome-icon icon="copy" />
                                </button>
                            </b-input-group-prepend>
                        </b-input-group>
                    </b-form-group>
                </b-card>

                <b-card v-if="!billingFieldsEmpty()">
                    <template #header>
                        <h5 class="mb-0 font-weight-bold">Campos Personalizados</h5>
                    </template>

                    <b-form @submit.prevent="putForm">

                        <b-form-group
                            v-for="(custom_field, index) in custom_fields"
                            :key="custom_field.key"
                        >
                            <template #label>
                                {{ custom_field.title }}
                            </template>

                            <b-input-group>
                                <b-form-textarea
                                    v-if="textAreaComponent(custom_fields[index])"
                                    v-model="custom_fields[index].value"
                                    rows="3"
                                >
                                </b-form-textarea>
                                <b-form-input
                                    v-else
                                    v-model="custom_fields[index].value"
                                    type="text"
                                    placeholder=""
                                >
                                </b-form-input>
                                <b-input-group-prepend is-text>
                                    <b-form-checkbox v-model="custom_fields[index].visible">
                                        {{ custom_fields[index].visible ? 'Ocultar' : 'Mostrar' }}
                                    </b-form-checkbox>
                                </b-input-group-prepend>
                            </b-input-group>
                        </b-form-group>

                        <br>
                        <div class="text-right">
                            <b-button type="submit" variant="primary">Guardar</b-button>
                        </div>
                    </b-form>
                </b-card>
            </b-col>
            <b-col :md="!isElectronicBill() ? '10' : '8'" sm="12">
                <b-card>
                    <div class="bg-primary total-header text-center">
                        {{ sale.total ? 'Q ' + sale.total : '' }}
                    </div>
                    <br>

                    <b-row v-if="controller === 'quotations'">
                        <b-col md="4" sm="12">
                            <h5> <b>  Datos generales </b> </h5>
                            <b> Fecha: </b> {{ date.datetime(sale.created_at) }} <br>
                            <b> Método de pago: </b> {{ payment_method.name }} <br>
                        </b-col>

                        <b-col md="4">
                            <h5> <b>  Detalles de cotización </b> </h5>
                            <b> Cantidad recibida: </b> {{ sale.received_amount }} <br>
                            <b> Vuelto: </b> {{ sale.change }} <br>
                        </b-col>

                        <b-col md="4" sm="12">
                            <h5> <b>  Datos de cliente </b> </h5>
                            <b> Nombre: </b> {{ sale.client_name }} <br>
                            <b> Teléfono: </b> {{ sale.client_telephone }} <br>
                            <b> E-Mail: </b> {{ client.client_email }} <br>
                        </b-col>
                    </b-row>
                    <b-row v-else>
                        <b-col md="4" sm="12">
                            <h5> <b>  Datos generales </b> </h5>
                            <b> Fecha: </b> {{ date.datetime(sale.sale_date) }} <br>
                            <b> Tipo de venta: </b> {{ sale.sale_type_translated }} <br>
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
                        <b-col class="text-center" md="6" v-if="!sale.status && controller !== 'quotations'">
                            <h1 class="text-danger"> {{ 'ANULADA' }} </h1>
                        </b-col>
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
                        <b-button variant="primary" @click="printDocument()">
                            <font-awesome-icon icon="print"/> Imprimir
                        </b-button>
                    </div>
                </b-card>
            </b-col>
        </b-row>
    </section>
</template>