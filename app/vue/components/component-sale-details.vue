<script>
export default {

    props: {
        products: {
            type: Array,
            required: true
        },
        payment_method_discount: {
            required: false,
            default: () => {
                return {}
            }
        }
    },

    components:{},

    data(){
        return {
            product: {
                id: null
            },
            product_quantity: 1,
            fields: [{
                label: 'Artículo',
                key: 'name',
                sortable: true
            },{
                label: 'Unidad',
                key: 'unit'
            },{
                label: 'Cantidad',
                key: 'saleQuantity'
            },{
                label: 'Precio',
                key: 'price'
            },{
                label: 'Subtotal',
                key: 'subtotal'
            },{
                label: 'Descuento',
                key: 'discount'
            },{
                label: 'Total',
                key: 'total'
            },{
                label: '',
                key: 'actions'
            }]
        }
    },

    methods: {
        setProductQuantity(product){
            const index = this.products.findIndex(e => e.id === product.id)

            const productSaleQuantity = parseFloat(product.saleQuantity)
            const productmaxQuantity = parseFloat(product.quantity)

            if (productSaleQuantity <= 0) {
                const quantity = 1

                this.$set(this.products[index], 'saleQuantity', quantity)
                this.$set(this.products[index], 'subtotal', quantity * product.price)

                this.$toast.warning('Debe agregar al menos un artículo.')

                return
            }

            if (productSaleQuantity > productmaxQuantity && product.product_type === 'good') {
                const quantity = productmaxQuantity

                this.$set(this.products[index], 'saleQuantity', quantity)
                this.$set(this.products[index], 'subtotal', quantity * product.price)
            } else {
                this.$set(this.products[index], 'subtotal', productSaleQuantity * product.price)
            }

            this.setProductTotal(index, product)
        },

        setProductDiscountValue(product){
            const index = this.products.findIndex(e => e.id === product.id)

            this.$set(this.products[index], 'discount_percentage', (product.discount_value * 100) / product.subtotal)

            this.setProductTotal(index, product)
        },

        setProductDiscountPercentage(product){
            const index = this.products.findIndex(e => e.id === product.id)

            this.$set(this.products[index], 'discount_value', (product.subtotal * (product.discount_percentage / 100)))

            this.setProductTotal(index, product)
        },

        setProductTotal(index, product){
            this.$set(this.products[index], 'total', product.subtotal - product.discount_value)
        },

        removeProduct(product){
            this.$emit('remove', product)
        }
    },

    watch: {
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

            <template v-slot:cell(saleQuantity)="row">
                <b-row>
                    <b-col md="10">
                        <b-form-input
                            @change="setProductQuantity(row.item)"
                            size="sm"
                            type="number"
                            v-model="row.item.saleQuantity"
                            min="1"
                            :max="row.item.quantity"
                        >
                        </b-form-input>
                    </b-col>
                </b-row>
            </template>

            <template v-slot:cell(discount)="row">
                <b-row v-if="!payment_method_discount.value">
                    <b-col md="10">
                        <b-input-group>
                            <b-form-input
                                @change="setProductDiscountPercentage(row.item)"
                                size="sm"
                                type="number"
                                v-model="row.item.discount_percentage"
                                min="1"
                            >
                            </b-form-input>
                            <template #prepend>
                                <b-input-group-text >%</b-input-group-text>
                            </template>
                        </b-input-group>
                    </b-col>
                </b-row>
                <template v-else >
                    --
                </template>

                <b-row v-if="!payment_method_discount.value">
                    <b-col md="10">
                        <b-input-group>
                            <b-form-input
                                @change="setProductDiscountValue(row.item)"
                                size="sm"
                                type="number"
                                v-model="row.item.discount_value"
                                min="1"
                            >
                            </b-form-input>
                            <template #prepend>
                                <b-input-group-text >Q.</b-input-group-text>
                            </template>
                        </b-input-group>
                    </b-col>
                </b-row>
                <template v-else >
                    --
                </template>
            </template>

            <template v-slot:cell(actions)="row">
                <b-button size="sm" variant="outline-danger" @click.stop="removeProduct(row.item)" class="mr-1">
                    <font-awesome-icon icon="trash" />
                </b-button>
            </template>
        </b-table>
    </div>
</template>