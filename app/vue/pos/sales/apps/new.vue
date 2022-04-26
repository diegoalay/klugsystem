<script type="text/javascript">
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'
import componentProductsIcon from 'vueApp/components/component-products-icon.vue'
import componentSaleDetails from 'vueApp/components/component-sale-details.vue'

export default {
    components:{
        'component-autocomplete': componenentAutocomplete,
        'component-products-icon': componentProductsIcon,
        'component-sale-details': componentSaleDetails
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
            payment_method_interest: {},
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
        }
    },
    mounted(){
        this.getOptions()
    },
    methods: {
        submitSaleOrQuotation(event){
            if(event){
                event.preventDefault()
            }

            const url = this.url.pos('sales')
            let form = {
                sale: {
                    ... this.sale,
                    client_id: this.client.id,
                    subtotal: this.getSum('subtotal'),
                    total: this.getTotalSale(),
                    discount: this.getDiscount(),
                    interest: this.getInterest(),
                    change: this.getChange(),
                    products: this.products,
                    client: this.client,
                    cash_register: true
                }
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Venta realizada.')
                    this.$router.push(this.url.pos('sales/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getOptions(){
            const url = this.url.pos('sales/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
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
                value = this.products.map(e => e[key]).reduce((oldValue, newValue) => oldValue + newValue)
            }

            return parseFloat(value).toFixed(2)
        },

        getTotal(){
            return (this.getSum('subtotal') - this.getDiscount()).toFixed(2)
        },

        getDiscount(){
            let discount = 0
            const subtotal = this.getSum('subtotal')

            if (this.payment_method_discount.value) {
                if (this.payment_method_discount.key == 'discount_percentage') {
                    discount = subtotal * this.payment_method_discount.value
                } else if (this.payment_method_discount.key == 'discount_value') {
                    discount = this.payment_method_discount.value
                }
            } else {
                discount = this.getSum('discount_value')
            }

            return parseFloat(discount).toFixed(2)
        },

        getTotalWithInterest(){
            const total = this.getTotal()
            const interest = this.getInterest()

            return parseFloat(total) + parseFloat(interest)
        },

        getPaymentInterest(){
            let values = []
            const percentage = this.payment_method.interest_percentage
            const value = this.payment_method.interest_value

            if (this.payment_method.interest_percentage > 0) values.push({item: {value: (percentage/100), key: 'interest_percentage'}, text: `% ${percentage}`})
            if (this.payment_method.interest_value > 0) values.push({item: {value: value, key: 'interest_value'}, text: `Q. ${value}`})

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

            if (this.payment_method_interest.value) {
                if (this.payment_method_interest.key == 'interest_percentage') {
                    interest = this.getTotal() * this.payment_method_interest.value
                } else if (this.payment_method_interest.key == 'interest_value') {
                    interest = this.payment_method_interest.value
                }
            }

            return parseFloat(interest).toFixed(2)
        },


        getTotalSale(){
            return (parseFloat(this.sale.shipping_costs) + this.getTotalWithInterest()).toFixed(2)
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

        getChangeWithFormat(){
            return `Q ${this.getChange()}`
        },

        // Setters
        setReceivedAmount(){
            this.$set(this.sale, 'received_amount', this.getTotalSale())
        },

        // validators
        validateReceivedAmount(){
            if (this.sale.received_amount <= this.getTotalSale()){
                this.$toast.error('La cantidad es menor al valor total de la venta.')
                this.$set(this.sale, 'received_amount', this.getTotalSale())
            }
        },

        removeProduct(product){
            this.products = this.products.filter(e => e.id !== product.id)
        },

        addProduct(product){
            if (product.quantity <= 0) {
                this.$toast.error('El producto se encuentra agotado.')
                return
            }

            if (!product.id) {
                this.$toast.warning('Debes seleccionar un producto.')
                return
            }

            const index = this.products.findIndex(e => e.id === product.id)

            let saleQuantity = 1

            if (index !== -1) {
                saleQuantity = this.products[index].saleQuantity
                saleQuantity += 1
            }

            if (saleQuantity > product.quantity) {
                this.$toast.error('Artículos agotado.')

                saleQuantity = product.quantity
            }

            const subtotal = product.retail_price * saleQuantity
            const discount_value = 0
            const discount_percentage = (discount_value * 100) / subtotal

            const total = subtotal - discount_value

            const new_product = {
                id: product.id,
                name: product.name,
                price: parseFloat(product.retail_price),
                quantity: parseFloat(product.quantity),
                saleQuantity: saleQuantity,
                subtotal: subtotal,
                measurement_unit: product.measurement_unit_name,
                discount_value: discount_value,
                discount_percentage: discount_percentage,
                total: total
            }

            if (index !== -1) {
                this.$set(this.products, index, new_product)
            } else {
                this.products.push(new_product)
            }
        }
    },

    watch: {
        payment_method(value){
            if (value.id) {
                this.$set(this.sale, 'payment_method_id', value.id)
            } else {
                this.$set(this.sale, 'payment_method_id', null)
            }

            this.payment_method_discount = {}
            this.payment_method_interest = {}
        }
    }
}
</script>

<template>
    <section>
        <component-header-form :title="'Punto de venta'">
            <slot name="buttons">
                <b-button variant="outline-dark" class="mb-2" to="/pos/sales">
                    Listado <font-awesome-icon icon="list" />
                </b-button>

                <b-button variant="outline-primary" class="mb-2" href="#finish-sale">
                    <font-awesome-icon icon="cart-shopping" />
                    Vender
                </b-button>
            </slot>
        </component-header-form>
        <b-row>
            <b-col md="6" sm="12">
                <b-card no-body>
                    <component-products-icon
                        @addProduct="addProduct"
                    >
                    </component-products-icon>
                </b-card>
            </b-col>
            <b-col>
                <b-card>
                    <b-form>
                        <div class="bg-primary total-header text-center">
                            {{ getTotalSaleWithFormat() }}
                        </div>

                        <br>
                        <component-autocomplete
                            @select="(option) => client = option !== null ? option : {}"
                            text-field="billing_details"
                            placeholder="Buscar por número de nit"
                            :endpoint="url.crm('/clients/search').toString(false)"
                        />

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
                                        format="DD-MM-YYYY"
                                        v-model="sale.sale_date"
                                        placeholder=""
                                        required
                                    >
                                    </component-datepicker>
                                </b-form-group>
                            </b-col>

                            <b-col md="4" sm="12">
                                <b-form-group>
                                    <label> Tipo de venta <sup class="text-danger">*</sup> </label>
                                    <b-form-select required v-model="sale.sale_type" :options="options.sale_types">
                                        <template #first>
                                            <b-form-select-option :value="null"> Seleccione un tipo de venta  </b-form-select-option>
                                        </template>
                                    </b-form-select>
                                </b-form-group>
                            </b-col>
                            <b-col md="4" sm="12">
                                <b-form-group>
                                    <label> Método de pago <sup class="text-danger">*</sup> </label>
                                    <b-form-select required v-model="payment_method" :options="options.payment_methods">
                                        <template #first>
                                            <b-form-select-option :value="null"> Seleccione un método de pago  </b-form-select-option>
                                        </template>
                                    </b-form-select>
                                </b-form-group>
                            </b-col>
                        </b-row>

                        <template v-if="payment_method.id">
                            <b-row>
                                <b-col>
                                    <b-form-group v-if="getPaymentDiscounts().length > 0">
                                        <label> Descuento </label>
                                        <b-form-select
                                            v-model="payment_method_discount"
                                            :options="getPaymentDiscounts()"
                                            value-field="item"
                                        >
                                        </b-form-select>
                                    </b-form-group>
                                </b-col>

                                <b-col>
                                    <b-form-group v-if="getPaymentInterest().length > 0">
                                        <label> Interés </label>
                                        <b-form-select
                                            v-model="payment_method_interest"
                                            :options="getPaymentInterest()"
                                            value-field="item"
                                        >
                                        </b-form-select>
                                    </b-form-group>
                                </b-col>
                            </b-row>
                        </template>
                        <hr>

                        <component-sale-details
                            :products="products"
                            :payment_method_discount="payment_method_discount"
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
                                <b-input-group-text >Descuento</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getDiscountWithFormat()"> </b-form-input>
                        </b-input-group>
                        <b-input-group>
                            <template #prepend>
                                <b-input-group-text >Total</b-input-group-text>
                            </template>
                            <b-form-input disabled readonly class="text-right" :value="getTotalWithFormat()"> </b-form-input>
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
                                <b-input-group-text >Envío</b-input-group-text>
                            </template>
                            <b-form-input
                                min="0"
                                class="text-right"
                                v-model="sale.shipping_costs"
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
                                @change="validateReceivedAmount()"
                                v-model="sale.received_amount"
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
                                <b-button id="finish-sale" block variant="primary" type="submit" @click="submitSaleOrQuotation"> Vender </b-button>
                            </b-col>
                            <b-col clas="total-value">
                                <b-form-input readonly class="text-right" :value="getTotalSaleWithFormat()"> </b-form-input>
                            </b-col>
                        </b-row>
                    </b-form>
                </b-card>
            </b-col>
        </b-row>
    </section>
</template>