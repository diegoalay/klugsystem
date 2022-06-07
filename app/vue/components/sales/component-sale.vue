<script type="text/javascript">
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'
import componentProductsIcon from 'vueApp/components/component-products-icon.vue'
import componentSaleDetails from 'vueApp/components/sales/component-sale-details.vue'
import componentConfirmSale from 'vueApp/components/component-confirm-sale.vue'

export default {
    props: {
        app_module: {
            type: String,
            required: true
        },
        controller_name: {
            type: String,
            default: 'sales'
        },
        quotation: {
            type: Boolean,
            default: false
        },
        cash_register: {
            type: Boolean,
            default: false
        },
    },
    components:{
        'component-autocomplete': componenentAutocomplete,
        'component-products-icon': componentProductsIcon,
        'component-sale-details': componentSaleDetails,
        'component-confirm-sale': componentConfirmSale
    },
    data() {
        return {
            products: [],
            options: {},
            sale: {
                id: null,
                total: 0,
                subtotal: 0,
                discount: 0,
                shipping_costs: 0,
                sale_date: new Date(),
                sale_type: null,
                received_amount: 0,
                change: 0
            },
            client: {
                id: null
            },
            filters: {
                date_range: [
                    new Date((new Date().setDate((new Date().getDate()) - 30))),
                    new Date()
                ]
            },
            clearAutocompletes: {
                client: false,
            },
            payment_method: {
                id: null,
                value: null
            },
            payment_method_discount: {},
            payment_method_interest: {
                key: 'interest_percentage',
                value: 0
            },
            fields: [{
                label: 'Artículo',
                key: 'name',
                sortable: true
            },{
                label: 'Unidad',
                key: 'unit'
            },{
                label: 'Cantidad',
                key: 'quantity'
            },{
                label: 'Precio',
                key: 'price'
            },{
                label: 'Subtotal',
                key: 'subtotal'
            },{
                label: 'Descuento (%)',
                key: 'discount_percentage'
            },{
                label: 'Descuento (Q.)',
                key: 'discount_value'
            },{
                label: 'Total',
                key: 'total'
            },{
                label: '',
                key: 'actions'
            }],
            storedData: {}
        }
    },
    mounted(){
        this.storedData = this.storage.local('sale')

        this.getOptions()
    },
    methods: {
        confirmSale(){
            this.$bvModal.show('confirm-sale')
        },

        submitSale(sale_type){
            this.$bvModal.hide('confirm-sale')

            const url = this.url[this.app_module](this.controller_name)
            let form = {}
            if (this.quotation) {
                form = {
                    quotation: {
                        ... this.sale,
                        sale_type: sale_type,
                        subtotal: this.getSum('subtotal'),
                        subtotal1: this.getTotalWithInterest(),
                        subtotal2: this.getTotalWithDiscount(),
                        total: this.getTotalSale(),
                        discount: this.getDiscount(),
                        interest: this.getInterest(),
                        change: this.getChange(),
                        products: this.products
                    }
                }
            } else {
                form = {
                    sale: {
                        ... this.sale,
                        sale_type: sale_type,
                        client_id: this.client.id,
                        subtotal: this.getSum('subtotal'),
                        subtotal1: this.getTotalWithInterest(),
                        subtotal2: this.getTotalWithDiscount(),
                        total: this.getTotalSale(),
                        discount: this.getDiscount(),
                        interest: this.getInterest(),
                        change: this.getChange(),
                        products: this.products,
                        client: this.client,
                        cash_register: this.cash_register
                    }
                }
            }

            if (sale_type === 'electronic_bill') this.$loading(true)

            this.http.post(url, form).then(result => {
                if (sale_type === 'electronic_bill') this.$loading(false)

                if (result.successful) {
                    if (this.quotation) {
                        this.$toast.success('Cotización realizada exitosamente.')
                    } else {
                        this.$toast.success('Venta realizada exitosamente.')
                    }
                    this.$router.push(this.url[this.app_module](`${this.controller_name}/:id`, {id: result.data.id}).toString(false))
                } else {
                    if (sale_type === 'electronic_bill') {
                        this.$toast.error(result.error.message, {
                            timeout: 10000,
                        })
                    } else {
                        this.$toast.error(result.error.message, {
                            timeout: 4000,
                        })
                    }

                }
            }).catch(error => {
                console.log(error)
            })
        },

        getOptions(){
            const url = this.url[this.app_module](`${this.controller_name}/options`)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    if (this.storedData && this.storedData.payment_method_id) {
                        const found = this.options.payment_methods.find(e => e.value.id === this.storedData.payment_method_id)

                        if (found) {
                            this.payment_method = found.value
                        }
                    }
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        // Getters
        getSum(key){
            let value = 0

            if (this.products.length > 0)  {
                value = this.products.map(e => e[key]).reduce((oldValue, newValue) => {
                    let val1 = parseFloat(oldValue)
                    let val2 = parseFloat(newValue)

                    if (Number.isNaN(val1)) val1 = 0
                    if (Number.isNaN(val2)) val2 = 0

                    return val1 + val2
                })
            }

            return parseFloat(value).toFixed(2)
        },

        getTotal(){
            return parseFloat(this.getSum('subtotal')).toFixed(2)
        },

        getDiscount(){
            let discount = 0
            const subtotal = this.getSum('subtotal')

            if (this.payment_method && this.payment_method_discount.value) {
                if (this.payment_method_discount.key == 'discount_percentage') {
                    discount = subtotal * this.payment_method_discount.value
                } else if (this.payment_method_discount.key == 'discount_value') {
                    discount = this.payment_method_discount.value
                }
            } else {
                discount = this.getSum('discount_value')
            }

            return parseFloat(discount||0).toFixed(2)
        },

        getTotalWithInterest(){
            const total = this.getTotal()
            const interest = this.getInterest()

            return (parseFloat(total) + parseFloat(interest)).toFixed(2)
        },

        getTotalWithDiscount(){
            return parseFloat(parseFloat(this.getTotalWithInterest()) - parseFloat(this.getDiscount())).toFixed(2)
        },

        getPaymentInterest(){
            let values = []
            const percentage = this.payment_method.interest_percentage
            const value = this.payment_method.interest_value

            if (this.payment_method.interest_percentage > 0) values.push({item: {value: (percentage/100), key: 'interest_percentage'}, text: `% ${percentage}`})


            values.push({item: {value: 0, key: 'interest_percentage'}, text: `N/A`})

            return values
        },

        getPaymentDiscounts(){
            let values = []
            const percentage = this.payment_method.discount_percentage
            const value = this.payment_method.discount_value

            if (this.payment_method.discount_percentage > 0) values.push({item: {value: (percentage/100), key: 'discount_percentage'}, text: `% ${percentage}`})
            if (this.payment_method.discount_value > 0) values.push({item: {value: value, key: 'discount_value'}, text: `Q. ${value}`})

            return values
        },

        getInterest(){
            let interest = 0

            if (this.payment_method && this.payment_method_interest.value) {
                if (this.payment_method_interest.key == 'interest_percentage') {
                    interest = this.getTotal() * this.payment_method_interest.value
                }
            }

            return parseFloat(interest).toFixed(2)
        },


        getTotalSale(){
            return (this.sale.shipping_costs + parseFloat(this.getTotalWithDiscount())).toFixed(2)
        },

        getChange(){
            return (parseFloat(this.sale.received_amount) - this.getTotalSale()).toFixed(2)
        },

        getSumWithFormat(key){
            const sum = this.getSum(key)
            return `Q ${sum}`
        },

        getDiscountWithFormat(){
            return `Q ${this.getDiscount()}`
        },

        getTotalWithFormat(){
            return `Q ${this.getTotal()}`
        },

        getTotalSaleWithFormat(){
            return `Q ${this.getTotalSale()}`
        },

        getInterestWithFormat(){
            return `Q ${this.getInterest()}`
        },

        getTotalWithInterestAndFormat(){
            return `Q ${this.getTotalWithInterest()}`
        },

        getTotalWithDiscountAndFormat(){
            return `Q ${this.getTotalWithDiscount()}`
        },

        getChangeWithFormat(){
            return `Q ${this.getChange()}`
        },

        getReceivedAmount(){
            return this.sale.received_amount
        },

        // Setters
        setShippingCosts(value){
            if (Number.isNaN(value) || value === '') {
                this.sale.shipping_costs = 0

                return
            }

            this.sale.shipping_costs = parseFloat(parseFloat(value).toFixed(2))
        },

        setReceivedAmount(){
            this.$set(this.sale, 'received_amount', this.getTotalSale())
        },

        // validators
        validateReceivedAmount(){
            if (this.sale.received_amount <= this.getTotalSale()){
                this.$toast.error('La cantidad es menor al valor total de la venta.')
                this.$set(this.sale, 'received_amount', this.getTotalSale())
            } else if (Number.isNaN(value) || value === '') {
                this.received_amount = 0.0
            } else {
                this.received_amount = parseFloat(parseFloat(value).toFixed(2))
            }
        },

        removeProduct(product){
            this.products = this.products.filter(e => e.id !== product.id)
        },

        addProduct(product){
            if (product.quantity <= 0 && product.product_type === 'good') {
                this.$toast.error('El producto se encuentra agotado.')
                return
            }

            if (!product.id) {
                this.$toast.warning('Debes seleccionar un producto.')
                return
            }

            const index = this.products.findIndex(e => e.id === product.id)

            let saleQuantity = 1
            let discount_percentage = 0
            if (index !== -1) {
                saleQuantity = this.products[index].saleQuantity
                saleQuantity += 1

                discount_percentage = this.products[index].discount_percentage
            }

            if (saleQuantity > product.quantity && product.product_type === 'good') {
                this.$toast.error('Artículos agotado.')

                saleQuantity = product.quantity
            }

            const subtotal = product.retail_price * saleQuantity
            let interest_value = 0
            let interest_percentage = 0

            if (this.payment_method_interest.key == 'interest_percentage') {
                interest_percentage = this.payment_method_interest.value
                interest_value = parseFloat(parseFloat(subtotal * interest_percentage).toFixed(2))
            }

            const final_subtotal = subtotal + interest_value
            const discount_value = final_subtotal * discount_percentage
            const total = final_subtotal - discount_value

            const new_product = {
                id: product.id,
                name: product.name,
                price: parseFloat(product.retail_price),
                quantity: parseFloat(product.quantity),
                saleQuantity: saleQuantity,
                subtotal: subtotal,
                final_subtotal: final_subtotal,
                measurement_unit: product.measurement_unit_name,
                discount_value: discount_value,
                discount_percentage: discount_percentage,
                interest_value: interest_value,
                interest_percentage: interest_percentage,
                product_type: product.product_type,
                total: total
            }

            if (index !== -1) {
                this.$set(this.products, index, new_product)
            } else {
                this.products.push(new_product)
            }

            let type = 'servicio'
            if (product.product_type === 'good') {
                type = 'producto'
            }
            this.$toast.info(`El ${type} ${product.name} a sido agregado exitosamente.`)
        }
    },

    watch: {
        payment_method(value){
            if (value.id) {
                this.$set(this.sale, 'payment_method_id', value.id)
            } else {
                this.$set(this.sale, 'payment_method_id', null)
            }

            this.storage.local('sale', {
                payment_method_id: value.id
            })

            this.payment_method_discount = {}
            this.payment_method_interest = {
                key: 'interest_percentage',
                value: 0
            }
        }
    }
}
</script>

<template>
    <section>
        <component-header-form :title="quotation ? 'Cotización' : 'Venta'">
            <slot name="buttons">
                <b-button variant="outline-dark" class="mb-2" to="/finance/sales">
                    Listado <font-awesome-icon icon="list" />
                </b-button>

                <b-button variant="outline-primary" class="mb-2" href="#finish">
                    <font-awesome-icon icon="cart-shopping" />
                    {{ quotation ? 'Terminar cotización' : 'Terminar venta' }}
                </b-button>
            </slot>
        </component-header-form>
        <b-row>
            <b-col md="5" sm="12">
                <b-card no-body>
                    <component-products-icon
                        @addProduct="addProduct"
                    >
                    </component-products-icon>
                </b-card>
            </b-col>
            <b-col md="7" sm="12">
                <b-card>
                    <b-form>
                        <div class="bg-primary total-header text-center">
                            {{ getTotalSaleWithFormat() }}
                        </div>

                        <br>
                        <component-autocomplete
                            v-if="!quotation"
                            @select="(option) => client = option !== null ? option : {}"
                            text-field="billing_details"
                            placeholder="Buscar por número de nit"
                            :endpoint="url.crm('/clients/search').toString(false)"
                        />

                        <b-row v-if="quotation">
                            <b-col md="6" sm="12">
                                <b-form-group>
                                    <label> Nombre <sup class="text-danger">* </sup> </label>
                                    <b-form-input
                                        ref="client-name"
                                        v-model="sale.client_name"
                                        type="text"
                                        placeholder=""
                                        required
                                    >
                                    </b-form-input>
                                </b-form-group>
                            </b-col>
                            <b-col md="6" sm="12">
                                <b-form-group>
                                    <label> E-Mail </label>
                                    <b-form-input
                                        v-model="sale.client_email"
                                        type="email"
                                        placeholder=""
                                    >
                                    </b-form-input>
                                </b-form-group>
                            </b-col>
                        </b-row>
                        <template v-else>
                            <b-row>
                                <b-col md="6" sm="12">
                                    <b-form-group>
                                        <label> Nit <sup class="text-danger">*</sup> </label>
                                        <b-form-input
                                            v-model="client.billing_identifier"
                                            type="text"
                                            placeholder=""
                                            required
                                        >
                                        </b-form-input>
                                    </b-form-group>
                                </b-col>
                                <b-col md="6" sm="12">
                                    <b-form-group>
                                        <label> Nombre <sup class="text-danger">* </sup> </label>
                                        <b-form-input
                                            ref="client-name"
                                            v-model="client.billing_name"
                                            type="text"
                                            placeholder=""
                                            required
                                        >
                                        </b-form-input>
                                    </b-form-group>
                                </b-col>
                            </b-row>

                            <b-row>
                                <b-col md="6" sm="12">
                                    <b-form-group>
                                        <label> Dirección </label>
                                        <b-form-input
                                            v-model="client.billing_address"
                                            type="text"
                                            placeholder=""
                                            required
                                        >
                                        </b-form-input>
                                    </b-form-group>
                                </b-col>
                                <b-col md="6" sm="12">
                                    <b-form-group>
                                        <label> E-Mail </label>
                                        <b-form-input
                                            v-model="client.billing_email"
                                            type="email"
                                            placeholder=""
                                        >
                                        </b-form-input>
                                    </b-form-group>
                                </b-col>
                            </b-row>
                        </template>

                        <b-row>
                            <b-col md="6" sm="12">
                                <b-form-group>
                                    <label> Método de pago <sup class="text-danger">*</sup> </label>
                                    <b-form-select required v-model="payment_method" :options="options.payment_methods">
                                        <template #first>
                                            <b-form-select-option :value="null"> Seleccione un método de pago  </b-form-select-option>
                                        </template>
                                    </b-form-select>
                                </b-form-group>
                            </b-col>

                            <b-col md="6" sm="12">
                                <template v-if="payment_method.id">
                                    <b-form-group v-if="getPaymentInterest().length > 1">
                                        <label> Interés </label>
                                        <b-form-select
                                            v-model="payment_method_interest"
                                            :options="getPaymentInterest()"
                                            value-field="item"
                                        >
                                        </b-form-select>
                                    </b-form-group>
                                </template>
                            </b-col>
                        </b-row>

                        <b-row>
                            <b-col md="4" sm="12">
                                <b-form-group>
                                    <template #label>
                                        Fecha de emisión <sup class="text-danger">*</sup>
                                    </template>
                                    <component-datepicker
                                        :focus="false"
                                        lang="es"
                                        type="date"
                                        format="DD-MM-YYYY HH:mm"
                                        v-model="sale.sale_date"
                                        placeholder=""
                                        required
                                    >
                                    </component-datepicker>
                                </b-form-group>
                            </b-col>
                        </b-row>

                        <hr>

                        <component-sale-details
                            :products="products"
                            :payment_method_discount="payment_method_discount"
                            :payment_method_interest="payment_method_interest"
                            @remove="removeProduct"
                        >
                        </component-sale-details>

                        <hr>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Subtotal</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getSumWithFormat('subtotal')"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Interés</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getInterestWithFormat()"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Total</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getTotalWithInterestAndFormat()"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Descuento</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getDiscountWithFormat()"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Total</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getTotalWithDiscountAndFormat()"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Envío</b-input-group-text>
                            </template>
                            <b-form-input
                                min="0"
                                type="number"
                                class="text-right"
                                @change="setShippingCosts"
                            >
                            </b-form-input>
                        </b-input-group>

                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Cantidad recibida</b-input-group-text>
                            </template>
                            <b-form-input
                                class="text-right"
                                type="number"
                                @change="validateReceivedAmount"
                                :value="getReceivedAmount()"
                                :min="getTotalSale()"
                            >
                            </b-form-input>
                            <b-input-group-append>
                                <b-button variant="outline-primary" @click="setReceivedAmount()"><font-awesome-icon icon="copy" /></b-button>
                            </b-input-group-append>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Cambio</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getChangeWithFormat()"> </b-form-input>
                        </b-input-group>
                        <hr>
                        <br>
                        <b-row>
                            <b-col cols="6">
                                <b-button v-if="!quotation" id="finish" block variant="primary" type="submit" @click.prevent="confirmSale"> Vender </b-button>
                                <b-button v-else id="finish" block variant="primary" type="submit" @click.prevent="submitSale"> Cotizar </b-button>
                            </b-col>
                            <b-col clas="total-value">
                                <b-form-input readonly class="text-right" :value="getTotalSaleWithFormat()"> </b-form-input>
                            </b-col>
                        </b-row>
                    </b-form>
                </b-card>
            </b-col>

            <b-modal
                id="confirm-sale"
                size="xl"
                hide-footer
                centered
                content-class="shadow"
                title="Seleccione tipo de venta"
            >
                <component-confirm-sale :sale_types="options.sale_types" @submit="submitSale" :total="getTotalSaleWithFormat()"/>
            </b-modal>
        </b-row>
    </section>
</template>