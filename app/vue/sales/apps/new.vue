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
                    billing_date: new Date()
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
                    departments: [],
                    branch_offices: []
                },
                filters: {
                    brand_id: null,
                    department_id: null,
                    branch_office_id: null,
                    products_start_date: new Date(),
                    products_end_date: new Date(),
                }
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

                if (!(product.quantity <= product.maxQuantity)) {
                    this.products[index].subtotal = product.quantity * product.price
                } else {
                    const quantity = produc.maxQuantity

                    this.products[index].quantity = quantity
                    this.products[index].subtotal = quantity * product.price
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
                const product = this.product
                const quantity = this.product_quantity

                const subtotal = product.retail_price * quantity
                const discount_value = 0
                const discount_percentage = (discount_value * 100) / subtotal

                const total = subtotal - discount_value

                this.products.push({
                    id: product.id,
                    name: product.name,
                    price: product.retail_price,
                    maxQuantity: product.quantity,
                    quantity: quantity,
                    subtotal: subtotal,
                    discount_value: discount_value,
                    discount_percentage: discount_percentage,
                    total: total
                })
            },


            getSum(key){
                let value = 0

                if (this.products.length > 0)  {
                    value = this.products.map(e => e[key]).reduce((oldValue, newValue) => oldValue + newValue)
                }

                return `Q ${value}`
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
                <b-col cols="8">
                    <b-card>
                        <b-form>
                            <b-row>
                                <b-col md="7" sm="12">
                                    <component-autocomplete
                                        :placeholder="`Buscar por nombre o sku`"
                                        text-field="details"
                                        :endpoint="'/products/search'"
                                        @select="(option) => product = option"
                                        :required="true"
                                    >
                                        <slot name="buttons">
                                            <b-input-group-prepend>
                                                <b-button :disabled="!product.id" @click="product = {id: null}"><font-awesome-icon icon="times" /></b-button>
                                                &nbsp;
                                                <b-button variant="primary"><font-awesome-icon :icon="isProductViewSearchType() ? 'search' : 'pencil-alt'" /></b-button>

                                            </b-input-group-prepend>
                                        </slot>
                                    </component-autocomplete>
                                </b-col>
                                <b-col cols="3">
                                    <b-form-group>
                                        <b-input-group>
                                            <b-form-input
                                                type="number"
                                                placeholder="Ingrese cantidad"
                                                v-model="product_quantity"
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
                                <b-row>
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
                            </template>

                            <template v-slot:cell(discount_value)="row">
                                <b-row>
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
                            </template>

                            <template v-slot:cell(actions)="row">
                                <b-button size="sm" variant="outline-danger" @click.stop="products.fillter(e => e.id !== row.item.id)" class="mr-1">
                                    <b-icon icon="trash-fill"></b-icon>
                                </b-button>
                            </template>
                        </b-table>
                    </b-card>
                </b-col>
                <b-col>
                    <b-card>
                        <b-tabs nav-class="font-weight-bold" fill>
                            <b-tab variant="outline-primary" :title="`Detalles de ${getText()}`" active>
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
                                <hr>

                                <b-input-group>
                                    <template #prepend>
                                        <b-input-group-text >Subtotal</b-input-group-text>
                                    </template>
                                    <b-form-input class="text-right" :value="getSum('subtotal')"> </b-form-input>
                                </b-input-group>

                                <b-input-group>
                                    <template #prepend>
                                        <b-input-group-text >Descuento</b-input-group-text>
                                    </template>
                                    <b-form-input class="text-right" :value="getSum('discount_value')"> </b-form-input>
                                </b-input-group>
                                <br>
                                <b-row>
                                    <b-col cols="8">
                                        <b-button block variant="primary" @click="completeSale()"> {{ isViewSaleType() ? 'Vender' : 'Cotizar' }} </b-button>
                                    </b-col>
                                    <b-col clas="total-value">
                                        <b-form-input class="text-right" :value="getSum('total')"> </b-form-input>
                                    </b-col>
                                </b-row>
                            </b-tab>
                            <b-tab title="Buscar">
                                <b-tabs fill>
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
            </b-row>
    </section>
</template>