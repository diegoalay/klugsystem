<script>
import componentItem from 'vueApp/components/sales/component-item.vue'


export default {
    components: {
        'component-item': componentItem
    },
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
        },
        payment_method_interest: {
            required: false,
            default: () => {
                return {}
            }
        },
        manualSale: {
            type: Boolean,
            default: false

        },
        options: {
            type: Object,
            default: () => {
                return {}
            }
        }
    },
    data(){
        return {
            item: {
                id: null
            },
            product_quantity: 1,
            fields: [],
            items: [],
        }
    },
    mounted(){
        if (this.manualSale) {
            this.manualSaleFields()
        } else {
            this.normalSaleFields()
        }

        if (this.tools.isMobile()) {
            this.fields.unshift({
                label: '',
                key: 'actions'
            })
        } else {
            this.fields.push({
                label: '',
                key: 'actions'
            })
        }
    },
    methods: {
        normalSaleFields(){
            this.fields = [{
                label: 'Artículo',
                key: 'name',
                sortable: true
            },{
                label: 'Unidad',
                key: 'measurement_unit'
            },{
                label: 'Cantidad',
                key: 'saleQuantity'
            },{
                label: 'Precio',
                key: 'price'
            },{
                label: 'Interés',
                key: 'interest'
            },{
                label: 'Subtotal',
                key: 'final_subtotal'
            },{
                label: 'Descuento',
                key: 'discount'
            },{
                label: 'Total',
                key: 'total'
            }]
        },
        manualSaleFields(){
            this.fields = [{
                label: '#',
                key: 'index',
                sortable: true,
            },{
                label: 'Unidad',
                key: 'measurement_unit',
                thClass: 'item-measurement-unit-header',
                required: true
            },{
                label: 'B/S',
                key: 'product_type',
                thClass: 'item-type-header',
                required: true
            },{
                label: 'Descripción',
                key: 'name',
                thClass: 'item-name-header',
                required: true
            },{
                label: 'Valor',
                key: 'price',
                thClass: 'item-price-header',
                tdClass: 'item-price-header',
                required: true
            },{
                label: 'Cantidad',
                key: 'saleQuantity',
                thClass: 'item-quantity-header',
                tdClass: 'item-quantity-header',
                required: true
            },{
                label: 'Interés',
                key: 'interest'
            },{
                label: 'Subtotal',
                key: 'final_subtotal'
            },{
                label: 'Descuento',
                key: 'discount',
                thClass: 'item-discount-header'
            },{
                label: 'Total',
                key: 'total'
            }]
        },
        setProductQuantity(item){
            if (this.manualSale) {
                this.setProductQuantityManual(item)
            } else {
                this.setProductQuantityNormal(item)
            }
        },
        setProductQuantityManual(item){
            const index = this.products.findIndex(e => e.id === item.id)

            let productSaleQuantity = parseFloat(item.saleQuantity)
            if (Number.isNaN(productSaleQuantity)) productSaleQuantity = 0

            this.$set(this.products[index], 'subtotal', productSaleQuantity * item.price)
            this.setProductTotal(index, item)
        },
        setProductQuantityNormal(item){
            const index = this.products.findIndex(e => e.id === item.id)

            const productSaleQuantity = parseFloat(item.saleQuantity)
            const productmaxQuantity = parseFloat(item.quantity)

            if (productSaleQuantity <= 0) {
                const quantity = 1

                this.$set(this.products[index], 'saleQuantity', quantity)
                this.$set(this.products[index], 'subtotal', quantity * item.price)

                this.$toast.warning('Debe agregar al menos un artículo.')

                return
            }

            if (this.options.inventory_count && (productSaleQuantity > productmaxQuantity) && (item.product_type === 'good')) {
                const quantity = productmaxQuantity

                this.$set(this.products[index], 'saleQuantity', quantity)
                this.$set(this.products[index], 'subtotal', quantity * item.price)
            } else {
                this.$set(this.products[index], 'subtotal', productSaleQuantity * item.price)
            }

            this.setProductTotal(index, item)
        },
        setProductPriceManual(item){
            const index = this.products.findIndex(e => e.id === item.id)

            let price = parseFloat(item.price)

            if (Number.isNaN(price)) price = 0

            const productPrice = price
            this.$set(this.products[index], 'subtotal', (productPrice * parseFloat(item.saleQuantity)))
            this.setProductTotal(index, item)
        },
        setProductDiscountValue(item){
            let discount = item.discount_value||0
            let final_subtotal = item.final_subtotal||0

            if (Number.isNaN(discount)) discount = 0
            if (Number.isNaN(final_subtotal)) final_subtotal = 0

            const index = this.products.findIndex(e => e.id === item.id)
            const value = parseFloat(parseFloat((discount * 100) / final_subtotal).toFixed(2))

            this.$set(this.products[index], 'discount_percentage', value)

            this.setProductTotal(index, item)
        },

        setProductDiscountPercentage(item){
            let discount = item.discount_percentage||0
            let final_subtotal = item.final_subtotal||0

            if (Number.isNaN(discount)) discount = 0
            if (Number.isNaN(final_subtotal)) final_subtotal = 0

            const index = this.products.findIndex(e => e.id === item.id)
            const value = parseFloat(parseFloat((final_subtotal * (discount / 100))).toFixed(2))

            this.$set(this.products[index], 'discount_value', value)

            this.setProductTotal(index, item)
        },

        setProductDiscountPercentage(item){
            const index = this.products.findIndex(e => e.id === item.id)

            this.setProductTotal(index, item)
        },

        setProductTotal(index, item){
            let subtotal = item.subtotal
            let interest_percentage = item.interest_percentage
            let discount_percentage = item.discount_percentage

            if (Number.isNaN(subtotal)) subtotal = 0
            if (Number.isNaN(interest_percentage)) interest_percentage = 0
            if (Number.isNaN(discount_percentage)) discount_percentage = 0

            const interest_value = parseFloat(parseFloat(subtotal * interest_percentage).toFixed(2))
            const final_subtotal = parseFloat(parseFloat(subtotal + interest_value).toFixed(2))
            const discount_value = parseFloat(parseFloat(final_subtotal * (discount_percentage / 100))).toFixed(2)
            const total = parseFloat(parseFloat(final_subtotal - discount_value).toFixed(2))

            this.$set(this.products[index], 'discount_value', discount_value)
            this.$set(this.products[index], 'interest_value', interest_value)
            this.$set(this.products[index], 'final_subtotal', final_subtotal)
            this.$set(this.products[index], 'total', total)
        },

        removeProduct(item){
            this.$emit('remove', item)
        },

        addManualItem(type, bill_template){
            let item = null

            const id = this.products.length + 1

            if (type === 'copy') {
                item = {
                    ...JSON.parse(JSON.stringify(this.products[this.products.length - 1])),
                    id: id
                }
            } else {
                item = {
                    id: id,
                    measurement_unit: bill_template ? bill_template.measurement_unit : null,
                    name: bill_template ? bill_template.name : '',
                    price: 0,
                    saleQuantity: 1,
                    subtotal: 0,
                    final_subtotal: 0,
                    discount_value: 0,
                    discount_percentage: 0,
                    interest_percentage: 0,
                    interest_value: 0,
                    product_type: bill_template ? bill_template.product_type : null,
                    total: 0
                }
            }

            this.products.push(item)


            this.showModal(item)
        },
        showModal(item){
            this.item = item

            this.$nextTick(()=>{
                this.openModal()
            })
        },
        openModal(){
            this.$bvModal.show('item-form')
        },
        hideModal(){
            this.$bvModal.hide('item-form')
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

        payment_method_interest(interest){
            for(let key in this.products) {
                let percentage = 0

                if (interest.key == 'interest_percentage') {
                    percentage = interest.value
                }

                this.$set(this.products[key], 'interest_percentage', percentage)
                this.setProductTotal(key, this.products[key])
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
        <b-modal
            v-if="item.id"
            id="item-form"
            size="xl"
            hide-footer
            centered
            content-class="shadow"
            :title="`Editar bien/servicio # ` + item.id"
        >
            <component-item
                @hide="hideModal"
                :item="item"
                :options="options"
                :payment_method_discount="payment_method_discount"
                :payment_method_interest="payment_method_interest"
                :setProductQuantity="setProductQuantity"
                :setProductPriceManual="setProductPriceManual"
                :setProductDiscountValue="setProductDiscountValue"
                :setProductDiscountPercentage="setProductDiscountPercentage"
            />
        </b-modal>
        <br>
        <br>
        <b-table
            v-if="manualSale"
            responsive
            striped
            hover
            :items="products"
            :fields="fields"
        >

            <template #head()="{ label, field: { required }}">
                {{ label }}
                <sup v-if="required" class="text-danger">*</sup>
            </template>

           <template v-slot:cell(index)="row">
               {{ row.item.id }}
            </template>

            <template v-slot:cell(product_type)="row" class="col-md-2">
                <b-form-select
                    v-model="row.item.product_type"
                    :options="options.product_types"
                >
                </b-form-select>
            </template>

            <template v-slot:cell(measurement_unit_name)="row" class="col-md-2">
                <b-form-select
                    :ref="`item-${row.item.id}`"
                    v-model="row.item.measurement_unit"
                    :options="options.measurement_units"
                >
                </b-form-select>
            </template>

           <template v-slot:cell(name)="row">
                <b-form-textarea
                    v-model="row.item.name"
                    placeholder="Ingrese descripción"
                    autocomplete="off"
                    rows="5"
                >
                </b-form-textarea>
            </template>

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
                            autocomplete="off"
                        >
                        </b-form-input>
                    </b-col>
                </b-row>
            </template>

           <template v-slot:cell(price)="row">
                <b-form-input
                    @change="setProductPriceManual(row.item)"
                    size="sm"
                    type="number"
                    v-model="row.item.price"
                    min="0"
                    autocomplete="off"
                >
                </b-form-input>
            </template>

           <template v-slot:cell(interest)="row">
                {{ row.item.interest_value }}
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
                                autocomplete="off"
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
                                autocomplete="off"
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
        </b-table>

        <b-table
            v-else
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
                            :max="options.inventory_count ? row.item.quantity : null"
                            autocomplete="off"
                        >
                        </b-form-input>
                    </b-col>
                </b-row>
            </template>

           <template v-if="options.product_price_editable" v-slot:cell(price)="row">
                <b-form-input
                    @change="setProductPriceManual(row.item)"
                    size="sm"
                    type="number"
                    v-model="row.item.price"
                    min="0"
                    step="any"
                    autocomplete="off"
                >
                </b-form-input>
            </template>

           <template v-slot:cell(interest)="row">
                {{ row.item.interest_value }}
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
                                autocomplete="off"
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
                                autocomplete="off"
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

                <b-button size="sm" variant="outline-primary" @click.stop="showModal(row.item)" class="mr-1">
                    <font-awesome-icon icon="pen-to-square" />
                </b-button>
            </template>
        </b-table>

        <div class="text-right" v-if="manualSale">
            <hr>
            <b-button v-if="products.length > 0" size="sm" @click="addManualItem('copy')" variant="primary" pill>
                <font-awesome-icon icon="copy" /> Copiar
            </b-button>
            <b-button size="sm" @click="addManualItem" variant="primary" pill>
                <font-awesome-icon icon="plus" /> Agregar
            </b-button>
            <b-button
                @click="addManualItem(null, bill_template)"
                class="bill-template-buttons"
                size="sm"
                variant="primary"
                pill
                v-for="bill_template in options.bill_templates"
                :key="bill_template.id"
            >
                {{ bill_template.title }}
            </b-button>
        </div>
    </div>
</template>

<style>
.bill-template-buttons {
    margin-right: 0.25rem;
}

.item-measurement-unit-header {
    width: 140px;
}

.item-name-header {
    width: 190px;
}

.item-type-header {
    width: 100px;
}

.item-quantity-header {
    width: 120px;
}

.item-price-header {
    width: 200px;
}

.item-discount-header {
    width: 225px;
}

.input-group-text {
  padding: 0.3rem 0.3rem;
}

</style>