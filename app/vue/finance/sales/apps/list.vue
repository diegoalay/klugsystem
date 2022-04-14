<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Fecha',
                    key: 'sale_date',
                    sortable: true
                },{
                    label: 'Cliente',
                    key: 'client_blling_name',
                    sortable: true
                },{
                    label: 'Nit',
                    key: 'client_billing_identifier',
                    sortable: true
                },{
                    label: 'Subtotal',
                    key: 'subtotal',
                    sortable: true
                },{
                    label: 'Descuento',
                    key: 'discount',
                    sortable: true
                },{
                    label: 'Intéres',
                    key: 'interest',
                    sortable: true
                },{
                    label: 'Total',
                    key: 'total',
                    sortable: true
                },{
                    label: 'Cantidad recibida',
                    key: 'received_amount',
                    sortable: true
                },{
                    label: 'Cambio',
                    key: 'change',
                    sortable: true
                },{
                    label: 'Usuario creador',
                    key: 'user_creator_name',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'sale_date',
                    order: true,
                },
                options: {
                    payment_methods: [],
                    sale_types: []
                },
                filters: {
                    search: '',
                    sale_type: '',
                    payment_method: '',
                    user_creator_type: ''
                },
                loading: false
            }
        },
        mounted() {
            this.list()
            this.getOptions()
        },
        methods: {
            list(){
                this.loading = true

                const url = this.url.finance('sales')
                .filters(this.filters)
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.records
                        this.pagination.total = response.data.total_count
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },

            getOptions(){
                const url = this.url.finance('sales/index_options')

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

            show(sale){
                this.$router.push(this.url.finance('sales/:id', {id: sale.id}).toString(false))
            },

            onSearch(text){
                this.filters.search = text

                this.list()
            },

            onFiltered(filteredItems) {
                this.totalRows = filteredItems.length
                this.currentPage = 1
            }
        },

        watch: {
            'pagination.current_page'() {
                this.list()
            },

            'pagination.order_by'() {
                this.list()
            },

            'pagination.order'(){
                this.list()
            }
        }
    }
</script>

<template>
    <section>
        <component-header-list
            title="Ventas"
            title-button-create="Vender"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch">
                <slot name="filters">
                    <b-form-select
                        v-model="filters.user_creator_type"
                        :options="options.user_creator_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todas </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <b-form-select
                        v-model="filters.sale_type"
                        :options="options.sale_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los tipos de ventas </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <b-form-select
                        v-model="filters.payment_method"
                        :options="options.payment_methods"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los métodos de pago </option>
                        </template>
                    </b-form-select>
                </slot>
            </component-search-list>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="data"
                    :fields="fields"
                    @filtered="onFiltered"
                    @row-clicked="show"
                    :sort-desc.sync="pagination.order"
                    :sort-by.sync="pagination.order_by"
                    responsive
                >
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((pagination.order) && (pagination.order_by === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!pagination.order) && (pagination.order_by === key))" icon="sort-up" />
                            </template>
                        </template>
                    </template>

                    <template v-slot:cell(sale_date)="row">
                        {{ date.datetime(row.item.created_at) }}
                    </template>

                    <template v-slot:cell(actions)="row">
                        <b-button @click="tools.printSale(row.item.id)" variant="outline-dark" class="mr-1">
                            <font-awesome-icon icon="print" />
                        </b-button>
                    </template>
                </b-table>
                <b-col sm="4" md="4" class="my-1">
                    <b-pagination
                        v-model="pagination.current_page"
                        :simple="false"
                        :total-rows="pagination.total"
                        :per-page="pagination.per_page"
                        align="fill"
                        size="sm"
                        class="my-0"
                    ></b-pagination>
                </b-col>
            </b-card-body>
        </b-card>
    </section>
</template>