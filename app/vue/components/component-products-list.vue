<script>
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'
import componentCarousel from 'vueApp/finance/sales/components/product-carousel.vue'

export default {

    props: {
        showFilters: {
            type: Boolean,
            required: true
        },
        selectProductId: {
            type: Number,
            default: null
        },
        payment_method_discount: {
            type: Object,
            required: true
        }
    },

    components:{
        'component-carousel': componentCarousel,
        'component-autocomplete': componenentAutocomplete
    },

    data(){
        return {
            selectedProductId:  null,
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
                brand_id: null,
                department_id: null,
                branch_office_id: null
            },
            clearAutocompletes: {
                product: false
            },
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
        }
    },

    methods: {
        removeProduct(){
            this.product = {
                id: null
            }

            this.$set(this.clearAutocompletes, 'product', true)

            setTimeout(() => {
                this.$set(this.clearAutocompletes, 'product', false)
            }, 500)
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


        setProductQuantity(product){
            const index = this.products.findIndex(e => e.id === product.id)

            const productQuantity = parseFloat(product.quantity)
            const productmaxQuantity = parseFloat(product.maxQuantity)

            if (productQuantity <= 0) {
                const quantity = 1

                this.products[index].quantity = quantity
                this.products[index].subtotal = quantity * product.price

                this.$toast.warning('Debe agregar al menos un artículo.')

                return
            }

            if (productQuantity > productmaxQuantity) {
                const quantity = productmaxQuantity

                this.products[index].quantity = quantity
                this.products[index].subtotal = quantity * product.price
            } else {
                this.products[index].subtotal = productQuantity * product.price
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

        setProduct(option){
            this.product = option ? option : {}
        },

        validateQuantity(){
            if (!(parseFloat(this.product_quantity) > 0)) {
                this.product_quantity = 1
            }
        },

        showProduct(){
            this.$modal.show('carousel')
        },

        addProduct(){
            if (!this.product.id) {
                this.$toast.warning('Debes seleccionar un producto.')
                return
            }
            if (!this.product_quantity > 0) {
                this.$toast.warning('La cantidad debe ser mayor a 0.')
                return
            }

            const index = this.products.findIndex(e => e.id === this.product.id)
            let quantity = 0
            const max_quantity = parseFloat(this.product_quantity)

            if (index !== -1) {
                quantity = this.products[index].quantity + max_quantity
            } else {
                quantity = max_quantity
            }
            if (quantity > this.product.quantity) {
                this.$toast.error('Artículos agotado.')
                quantity = this.product.quantity
            }

            const subtotal = this.product.retail_price * quantity
            const discount_value = 0
            const discount_percentage = (discount_value * 100) / subtotal
            const total = subtotal - discount_value
            const new_product = {
                measurement_unit: this.product.measurement_unit_name,
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
    },

    watch: {
        selectProductId(product_id){
            if (product_id) {
                this.selectedProductId = product_id
            }
        },

        payment_method_discount(discount){
            if (discount.value) {
                for(let key in this.products) {
                    this.$set(this.products[key], 'discount_value', 0)
                }
            }
        },

        products(){
            this.$emit('updateProducts', this.products)
        }
    }
}
</script>

<template>
    <div>
        <modal name="carousel" :adaptive="true" height="auto">
            <component-carousel :product="product"/>
        </modal>

        <br>
        <br>

        <b-row v-show="showFilters">
            <b-col md="4" sm="12">
                <b-form-group label="Marca">
                    <b-form-select v-model="filters.brand_id" :options="options.brands">
                        <template #first>
                            <b-form-select-option :value="null"> Todas las marcas  </b-form-select-option>
                        </template>
                    </b-form-select>
                </b-form-group>
            </b-col>

            <b-col md="4" sm="12">
                <b-form-group label="Sucursal">
                    <b-form-select v-model="filters.branch_office_id" :options="options.branch_offices">
                        <template #first>
                            <b-form-select-option :value="null"> Todas las sucursales  </b-form-select-option>
                        </template>
                    </b-form-select>
                </b-form-group>
            </b-col>

            <b-col md="4" sm="12">
                <b-form-group label="Departamento">
                    <b-form-select v-model="filters.department_id" :options="options.departments">
                        <template #first>
                            <b-form-select-option :value="null"> Todos los departamentos </b-form-select-option>
                        </template>
                    </b-form-select>
                </b-form-group>
            </b-col>
        </b-row>

        <b-form>
            <b-row>
                <b-col :md="product.id ? '6' : '9' " sm="12">
                    <component-autocomplete
                        :placeholder="`Buscar por nombre o sku`"
                        :default-option-id="selectedProductId"
                        :search-on-focus="true"
                        text-field="details"
                        :endpoint="url.inventory('products/search').toString(false)"
                        @select="(option) => setProduct(option)"
                        :required="true"
                        :thumbnail="tools.getProductImage"
                        :show-thumbnail="true"
                        :clearOptions="clearAutocompletes.product"
                        component-id="sales-products"
                    >
                        <slot name="buttons">
                            <b-input-group-prepend>
                                <b-button @click="removeProduct()">
                                    <font-awesome-icon icon="xmark" />
                                </b-button>
                                &nbsp;
                                <b-button v-if="product.id" variant="outline-primary" @click.stop="showProduct()">
                                    <font-awesome-icon icon="info" />
                                </b-button>
                            </b-input-group-prepend>
                        </slot>
                    </component-autocomplete>
                </b-col>
                <b-col md="3" sm="12">
                    <b-form-group>
                        <b-input-group>
                            <b-form-input
                                type="number"
                                placeholder="Cantidad"
                                v-model="product_quantity"
                                @change="validateQuantity"
                                :max="product.quantity"
                                min="1"
                                required
                            >
                            </b-form-input>
                            <b-input-group-append>
                                <b-button required :disabled="!product_quantity" @click="product_quantity = ''"><font-awesome-icon icon="xmark" /></b-button>
                            </b-input-group-append>
                        </b-input-group>
                    </b-form-group>
                </b-col>
                <b-col md="3" sm="12" v-if="product.id">
                    <b-button variant="primary" @click.stop="addProduct()">
                        Agregar
                    </b-button>
                </b-col>
            </b-row>
        </b-form>


        <br>
        <br>
        <b-table
            class="table-scroll"
            responsive
            striped
            hover
            :items="products"
            :fields="fields"
        >

            <template v-slot:cell(quantity)="row">
                <b-row>
                    <b-col md="10">
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
                    <b-col md="10">
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
                    <b-col md="10">
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
                    <font-awesome-icon icon="trash" />
                </b-button>
            </template>
        </b-table>
    </div>
</template>