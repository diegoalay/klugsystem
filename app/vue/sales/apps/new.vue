<script type="text/javascript">
    import componenentAutocomplete from '../../components/component-autocomplete.vue'

    export default {
        components:{
            'component-autocomplete': componenentAutocomplete
        },
        data() {
            return {
                product_text: null,
                product_quantity: 0,
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
                    label: 'Descuento',
                    key: 'discount'
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

            addBrand(){
                if ((this.filters.brands.findIndex(e => e.id === this.brand.id)) !== -1) {
                    return
                }

                this.filters.brands.push(this.brand)
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
                        <b-row>
                            <b-col cols="7">
                                <component-autocomplete
                                    :placeholder="`Buscar por nombre o sku`"
                                    text-field="details"
                                    :endpoint="'/products/search'"
                                    @select="(option) => product = option"
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
                                    <b-button variant="primary">Agregar </b-button>
                                </b-form-group>
                            </b-col>
                        </b-row>
                        <br>
                        <b-table
                            striped
                            hover
                            :items="products"
                            :fields="fields"
                        >
                            <template v-slot:cell(actions)="row">
                                <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
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