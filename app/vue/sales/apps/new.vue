<script type="text/javascript">
    import componenentAutocomplete from '../../components/component-autocomplete.vue'

    export default {
        components:{
            'component-autocomplete': componenentAutocomplete
        },
        data() {
            return {
                product_text: null,
                product_quantity: 1,
                main_path: '/sales',
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
                products: [],
                sale: {
                    id: null,
                    total: 0,
                    subtotal: 0,
                    discount: 0,
                    shipping_costs: 0,
                    sale_date: new Date(),
                    sale_type: null
                },
                client: {
                    id: null
                },
                product: {
                    id: null
                },
                viewType: 'sale',
                productViewType: 'search',
                product_tags: [
                    {
                        text: 'nombre',
                        value: 'name'
                    },{
                        text: 'marca',
                        value: 'brand'
                    },{
                        text: 'sucursal',
                        value: 'branch_office'
                    },{
                        text: 'departamento',
                        value: 'department'
                    }
                ],
                options: {
                    brands: [],
                    sale_types: [],
                    departments: [],
                    branch_offices: [],
                    payment_methods: []
                },
                filters: {
                    brand_id: null,
                    department_id: null,
                    branch_office_id: null,
                    products_start_date: new Date(),
                    products_end_date: new Date(),
                },
                clearAutocompletes: {
                    product: false,
                    client: false,
                },

                payment_method: {
                    id: null
                },
                payment_method_discount: {},
                payment_method_interest: {},
            }
        },
        mounted(){
            this.getOptions()
        },
        methods: {
            getOptions(){
                const url = `${this.main_path}/options.json`

                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.options = result.data
                    } else {

                    }
                }).catch(error => {
                    console.log(error)
                })
            },

            switchViewType(){
                if (this.isViewSaleType()) {
                    this.viewType = 'quotation'
                } else {
                    this.viewType = 'sale'
                }
            },

            switchProductViewType(){
                if (this.isProductViewSearchType()) {
                    this.viewType = 'write'
                } else {
                    this.viewType = 'search'
                }
            },

            isViewSaleType(){
                return this.viewType === 'sale'
            },

            isProductViewSearchType(){
                return this.product_view_type == 'search'
            },

            getTitle(){
                return this.isViewSaleType() ? 'Cotización' : 'Venta'
            },

            getText(){
                return this.isViewSaleType() ? 'venta' : 'cotización'
            },

            setProductQuantity(product){
                const index = this.products.findIndex(e => e.id === product.id)

                if (product.quantity <= 0) {
                    const quantity = 1

                    this.products[index].quantity = quantity
                    this.products[index].subtotal = quantity * product.price

                    alert('Debes agregar al menos uno de este producto')

                    return
                }

                if (product.quantity > product.maxQuantity) {
                    const quantity = product.maxQuantity

                    this.products[index].quantity = quantity
                    this.products[index].subtotal = quantity * product.price
                } else {
                    this.products[index].subtotal = product.quantity * product.price
                }

                this.setProductTotal(index, product)
            },

            setProductDiscountValue(product){
                const index = this.products.findIndex(e => e.id === product.id)

                this.products[index].discount_percentage = (product.discount_value * 100) / product.subtotal

                this.setProductTotal(index, product)
            },

            setProductDiscountPercentage(product){
                const index = this.products.findIndex(e => e.id === product.id)

                this.products[index].discount_value = (product.subtotal * (product.discount_percentage / 100))

                this.setProductTotal(index, product)
            },

            setProductTotal(index, product){
                this.products[index].total = product.subtotal - product.discount_value
            },

            addProduct(){
                if (!this.product.id) {
                    alert('Debe seleccionar un producto.')
                    return
                }

                const index = this.products.findIndex(e => e.id === this.product.id)

                let quantity = 0
                const max_quantity = parseFloat(this.product_quantity)

                if (index !== -1) {
                    quantity = this.products[index].quantity + max_quantity
                } else {
                    quantity = max_quantity
                }

                if (quantity > this.product.quantity) {
                    alert('No cuenta con los suficientes productos.')

                    quantity = this.product.quantity
                }

                const subtotal = this.product.retail_price * quantity
                const discount_value = 0
                const discount_percentage = (discount_value * 100) / subtotal

                const total = subtotal - discount_value

                const new_product = {
                    id: this.product.id,
                    name: this.product.name,
                    price: this.product.retail_price,
                    maxQuantity: this.product.quantity,
                    quantity: quantity,
                    subtotal: subtotal,
                    discount_value: discount_value,
                    discount_percentage: discount_percentage,
                    total: total
                }

                if (index !== -1) {
                    this.$set(this.products, index, new_product)
                } else {
                    this.products.push(new_product)
                }
            },

            getSum(key){
                let value = 0

                if (this.products.length > 0)  {
                    value = this.products.map(e => e[key]).reduce((oldValue, newValue) => oldValue + newValue)
                }

                return value
            },

            getTotal(){
                return parseFloat(this.getSum('subtotal')) - this.getDiscount()
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

                return parseFloat(discount)
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

                return parseFloat(interest)
            },

            getTotalWithInterest(){
                const total = this.getTotal()
                const interest = this.getInterest()

                return parseFloat(total + interest)
            },

            getTotalSale(){
                return parseFloat(this.getTotal() + parseFloat(this.sale.shipping_costs) + this.getInterest())
            },

            getSumWithFormat(key){
                const sum = parseFloat(this.getSum(key)).toFixed(2)
                return `Q ${sum}`
            },

            getDiscountWithFormat(){
                return `Q ${this.getDiscount().toFixed(2)}`
            },

            getTotalWithFormat(){
                return `Q ${this.getTotal().toFixed(2)}`
            },

            getTotalSaleWithFormat(){
                return `Q ${this.getTotalSale().toFixed(2)}`
            },

            getInterestWithFormat(){
                return `Q ${this.getInterest().toFixed(2)}`
            },

            getTotalWithInterestAndFormat(){
                return `Q ${this.getTotalWithInterest().toFixed(2)}`
            },

            getProductDescription(){
                if (!this.product) return

                if (this.product.quantity === 0) {
                    return 'We will convert your name to lowercase instantly'
                }

                return null
            },

            removeProduct(){
                this.product = {id: null}
                this.clearAutocompletes.product = true
            },

            completeSale(event){
                if(event){
                    event.preventDefault()
                }
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

            // validators
            validateQuantity(){
                if (!(parseFloat(this.product_quantity) > 0)) {
                    alert('Valor inválido.')
                    this.product_quantity = 1
                }
            },

            validateShippingCosts(){
                if (!(parseFloat(this.product_quantity) >= 0)) {
                    alert('Costo de envío inválido.')
                    this.product_quantity = 0
                }
            }
        },

        watch: {
            payment_method(value){
                if (value.id) {
                    this.$set(this.sale, 'payment_methods_id', value.id)
                } else {
                    this.$set(this.sale, 'payment_methods_id', null)
                }

                this.payment_method_discount = {}
                this.payment_method_interest = {}
            },

            payment_method_discount(discount){
                if (discount.value) {
                    for(let key in this.products) {
                        this.$set(this.products[key], 'discount_value', 0)
                    }
                }
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            :title="isViewSaleType() ? 'Vender' : 'Cotizar'"
        >
            <slot name="buttons">
                <b-button variant="outline-dark" class="mb-2" @click="switchViewType()">
                    {{ getTitle() }}
                </b-button>

                <b-button variant="outline-dark" class="mb-2" to="/">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </slot>
        </component-header-form>
        <b-row>
            <b-col md="8" sm="12">
                <b-card>
                    <b-tabs nav-class="font-weight-bold" fill>
                        <br>
                        <br>

                        <b-tab title="Artículos">

                            <b-form>
                                <b-row>
                                    <b-col md="7" sm="12">
                                        <component-autocomplete
                                            :placeholder="`Buscar por nombre o sku`"
                                            text-field="details"
                                            :endpoint="'/products/search'"
                                            @select="(option) => product = option"
                                            :required="true"
                                            :clearOptions="clearAutocompletes.product"
                                            :description="getProductDescription()"
                                        >
                                            <slot name="buttons">
                                                <b-input-group-prepend>
                                                    <b-input-group-text v-if="product.id"> {{ product.quantity }} </b-input-group-text>

                                                    <b-button @click="removeProduct()"><font-awesome-icon icon="times" /></b-button>
                                                    &nbsp;
                                                    <b-button variant="primary"><font-awesome-icon :icon="isProductViewSearchType() ? 'search' : 'pencil-alt'" /></b-button>

                                                </b-input-group-prepend>
                                            </slot>
                                        </component-autocomplete>
                                    </b-col>
                                    <b-col md="3" sm="12">
                                        <b-form-group>
                                            <b-input-group>
                                                <b-form-input
                                                    type="number"
                                                    placeholder="Ingrese cantidad"
                                                    v-model="product_quantity"
                                                    @change="validateQuantity"
                                                    min="1"
                                                    required
                                                >
                                                </b-form-input>
                                                <b-input-group-append>
                                                    <b-button :disabled="!product_quantity" @click="product_quantity = ''"><font-awesome-icon icon="times" /></b-button>
                                                </b-input-group-append>
                                            </b-input-group>
                                        </b-form-group>
                                    </b-col>
                                    <b-col cols="2">
                                        <b-form-group>
                                            <b-button variant="primary" @click.stop="addProduct()"> Agregar </b-button>
                                        </b-form-group>
                                    </b-col>
                                </b-row>
                            </b-form>
                            <br>
                            <br>
                            <b-table
                                class="table-scroll"
                                striped
                                hover
                                :items="products"
                                :fields="fields"
                            >

                                <template v-slot:cell(quantity)="row">
                                    <b-row>
                                        <b-col md="7">
                                            <b-form-input
                                                @change="setProductQuantity(row.item)"
                                                size="sm"
                                                type="number"
                                                v-model="row.item.quantity"
                                                min="1"
                                                :max="row.item.maxQuantity"
                                            >
                                            </b-form-input>
                                        </b-col>
                                    </b-row>
                                </template>

                                <template v-slot:cell(discount_percentage)="row">
                                    <b-row v-if="!payment_method_discount.value">
                                        <b-col md="7">
                                            <b-form-input
                                                @change="setProductDiscountPercentage(row.item)"
                                                size="sm"
                                                type="number"
                                                v-model="row.item.discount_percentage"
                                                min="1"
                                            >
                                            </b-form-input>
                                        </b-col>
                                    </b-row>
                                    <template v-else >
                                        --
                                    </template>

                                </template>

                                <template v-slot:cell(discount_value)="row">
                                    <b-row v-if="!payment_method_discount.value">
                                        <b-col md="7">
                                            <b-form-input
                                                @change="setProductDiscountValue(row.item)"
                                                size="sm"
                                                type="number"
                                                v-model="row.item.discount_value"
                                                min="1"
                                            >
                                            </b-form-input>
                                        </b-col>
                                    </b-row>
                                    <template v-else >
                                        --
                                    </template>
                                </template>

                                <template v-slot:cell(actions)="row">
                                    <b-button size="sm" variant="outline-danger" @click.stop="products = products.filter(e => e.id !== row.item.id)" class="mr-1">
                                        <b-icon icon="trash-fill"></b-icon>
                                    </b-button>
                                </template>
                            </b-table>
                        </b-tab>
                        <b-tab title="Buscar">
                            <b-tabs vertical fill>
                                <b-tab title="Filtros">
                                    <br>
                                    <b-form-group label="Marca">
                                        <b-form-select v-model="filters.brand_id" :options="options.brands">
                                            <template #first>
                                                <b-form-select-option :value="null"> Todas las marcas  </b-form-select-option>
                                            </template>
                                        </b-form-select>
                                    </b-form-group>

                                    <b-form-group label="Sucursal">
                                        <b-form-select v-model="filters.branch_office_id" :options="options.branch_offices">
                                            <template #first>
                                                <b-form-select-option :value="null"> Todas las sucursales  </b-form-select-option>
                                            </template>
                                        </b-form-select>
                                    </b-form-group>

                                    <b-form-group label="Departamento">
                                        <b-form-select v-model="filters.department_id" :options="options.departments">
                                            <template #first>
                                                <b-form-select-option :value="null"> Todos los departamentos </b-form-select-option>
                                            </template>
                                        </b-form-select>
                                    </b-form-group>
                                </b-tab>
                                <b-tab title="Productos">
                                    <br>

                                    <p> <b> Buscar productos más vendidos </b> </p>
                                    <b-row>
                                        <b-col>
                                            <component-datepicker
                                                :focus="false"
                                                lang="es"
                                                valueType="format"
                                                format="DD-MM-YYYY"
                                                v-model="filters.products_start_date"
                                                placeholder="Desde">
                                            </component-datepicker>
                                        </b-col>
                                        <b-col>
                                            <component-datepicker
                                                :focus="false"
                                                lang="es"
                                                valueType="format"
                                                format="DD-MM-YYYY"
                                                v-model="filters.products_end_date"
                                                placeholder="Hasta">
                                            </component-datepicker>
                                        </b-col>
                                    </b-row>
                                </b-tab>
                            </b-tabs>
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

                        <component-autocomplete @select="(option) => client = option" text-field="details" placeholder="Buscar cliente ..." :endpoint="'/clients/search'" />

                        <b-row>
                            <b-col>
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
                            <b-col>
                                <b-form-group>
                                    <label> Nombre <sup class="text-danger">* </sup> </label>
                                    <b-form-input
                                        v-model="client.billing_name"
                                        type="text"
                                        placeholder=""
                                    >
                                    </b-form-input>
                                </b-form-group>
                            </b-col>
                        </b-row>

                        <b-row>
                            <b-col>
                                <b-form-group>
                                    <label> Dirección </label>
                                    <b-form-input
                                        v-model="client.billing_address"
                                        type="text"
                                        placeholder=""
                                    >
                                    </b-form-input>
                                </b-form-group>
                            </b-col>
                            <b-col>
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
                        <hr>

                        <b-form-group label="Fecha de emisión">
                            <component-datepicker
                                :focus="false"
                                lang="es"
                                valueType="format"
                                format="DD-MM-YYYY"
                                v-model="sale.billing_date"
                                placeholder="">
                            </component-datepicker>
                        </b-form-group>

                        <b-form-group>
                            <label> Tipo de venta <sup class="text-danger">*</sup> </label>
                            <b-form-select required v-model="sale.sale_types_id" :options="options.sale_types">
                                <template #first>
                                    <b-form-select-option :value="null"> Seleccione un tipo de venta  </b-form-select-option>
                                </template>
                            </b-form-select>
                        </b-form-group>

                        <b-form-group>
                            <label> Método de pago <sup class="text-danger">*</sup> </label>
                            <b-form-select required v-model="payment_method" :options="options.payment_methods">
                                <template #first>
                                    <b-form-select-option :value="null"> Seleccione un método de pago  </b-form-select-option>
                                </template>
                            </b-form-select>
                        </b-form-group>

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
                        <b-row>
                            <b-col cols="8">
                                <b-button block variant="primary" type="submit" @click.stop="completeSale()"> {{ isViewSaleType() ? 'Vender' : 'Cotizar' }} </b-button>
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