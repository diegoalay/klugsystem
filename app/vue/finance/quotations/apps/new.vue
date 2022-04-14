<script type="text/javascript">
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'
import componentProductsDetailsForm from 'vueApp/finance/components/products-details-form.vue'

export default {
    components:{
        'component-autocomplete': componenentAutocomplete,
        'component-products-details-form': componentProductsDetailsForm
    },
    data() {
        return {
            products: [],
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
            product: {
                id: null
            },
            productViewType: 'search',
            options: {
                brands: [],
                sale_types: [],
                departments: [],
                branch_offices: [],
                payment_methods: []
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
                id: null
            },
            payment_method_discount: {},
            payment_method_interest: {},
            showFilters: false
        }
    },
    mounted(){
        this.getOptions()
        this.getProductsTopSelled()
    },
    methods: {
        submitSaleOrQuotation(event){
            if(event){
                event.preventDefault()
            }

            const url = this.url.finance('sales')
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
                    client: this.client
                }
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Venta realizada.')
                    this.$router.push(this.url.finance('sales/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        getProductsTopSelled(){
            const url = this.url.inventory('products')
            .filters({
                top_products: true,
                start_date: this.filters.date_range[0] ?
                    this.filters.date_range[0].toISOString() :
                    '',
                end_date: this.filters.date_range[1] ?
                    this.filters.date_range[1].toISOString() :
                    '',
            })

            this.loadingTopProducts = true
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.topProducts = result.data
                } else {
                    this.$toast.error(result.error.message)
                }

                this.loadingTopProducts = false
            }).catch(error => {
                console.log(error)
            })
        },

        getOptions(){
            const url = this.url.finance('sales/options')

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

            return parseFloat(total + interest)
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
            return (parseFloat(this.getTotal() + parseFloat(this.sale.shipping_costs) + this.getInterest())).toFixed(2)
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

        validateShippingCosts(){
            if (!(parseFloat(this.product_quantity) >= 0)) {
                this.product_quantity = 0
            }
        },

        updateProducts(products) {
            this.products = products
        },

        selectProduct(product_id) {
            if (product_id) {
                this.selectProductId = product_id
                this.tabIndex = 0
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
        <component-header-form :title="'Vender'">
            <slot name="buttons">
                <b-button variant="outline-dark" class="mb-2" to="/finance/sales">
                    Listado <font-awesome-icon icon="list" />
                </b-button>

                <b-button variant="outline-primary" class="mb-2" @click.stop="showFilters = !showFilters">
                    <font-awesome-icon v-if="showFilters" icon="eye-slash" />
                    <font-awesome-icon v-else icon="filter" />
                    Filtros
                </b-button>

                <b-button variant="outline-primary" class="mb-2" href="#finish-sale">
                    <font-awesome-icon icon="cart-shopping" />
                    Vender
                </b-button>
            </slot>
        </component-header-form>
        <b-row>
            <b-col md="8" sm="12">
                <b-card no-body>
                    <b-tabs nav-class="font-weight-bold" card pills fill v-model="tabIndex">
                        <b-tab title="Artículos">
                            <component-products-details-form
                                :show-filters="showFilters"
                                :select-product-id="selectProductId"
                                :payment_method_discount="payment_method_discount"
                                @updateProducts="updateProducts"
                            >

                            </component-products-details-form>
                        </b-tab>
                        <b-tab title="Buscar">
                            <br>
                            <div class="d-flex justify-content-center">
                                <b-form-group label="Productos con mayor venta durante">
                                    <component-datepicker
                                        @change="getProductsTopSelled()"
                                        v-model="filters.date_range"
                                        lang="es"
                                        format="DD-MM-YYYY"
                                        range
                                        placeholder="Seleccione un rango de fechas"
                                    >
                                    </component-datepicker>
                                </b-form-group>
                            </div>
                            <br>
                            <b-table
                                v-if="!loadingTopProducts"
                                striped
                                hover
                                :items="topProducts"
                                :fields="topProductsfields"
                                responsive
                            >

                                <template v-slot:cell(actions)="row">
                                    <b-button variant="outline-success" @click.stop="selectProduct(row.item.id)">
                                        <font-awesome-icon icon="cart-plus" />
                                    </b-button>
                                </template>

                                <template v-slot:cell(thumbnail)="row">
                                    <b-img :src="tools.getProductImage(row.item)" width="50" rounded alt="image"> </b-img>
                                </template>
                            </b-table>
                        </b-tab>
                    </b-tabs>
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

                        <b-row>
                            <b-col md="6" sm="12">
                                <b-form-group>
                                    <label> Tipo de venta <sup class="text-danger">*</sup> </label>
                                    <b-form-select required v-model="sale.sale_type" :options="options.sale_types">
                                        <template #first>
                                            <b-form-select-option :value="null"> Seleccione un tipo de venta  </b-form-select-option>
                                        </template>
                                    </b-form-select>
                                </b-form-group>
                            </b-col>
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
                                class="text-right"
                                @change="validateShippingCosts"
                                v-model="sale.shipping_costs"
                            >
                            </b-form-input>
                        </b-input-group>
                        <hr>
                        <br>
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
                                <b-button id="finish-sale" block variant="primary" type="submit" @click.prevent="submitSaleOrQuotation"> {{ 'Vender' }} </b-button>
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