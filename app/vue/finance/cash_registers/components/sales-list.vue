<script type="text/javascript">
    export default {
        props: {
            cash_register: {
                required: true,
                type: Object
            }
        },
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
                    payment_method: ''
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

                const url = this.url.build('sales')
                .filters(this.filters)
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.sales
                        this.pagination.total = response.data.total_count
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },

            getOptions(){
                const url = this.url.build('sales/index_options')

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

            show(sale_id){
                this.$router.push(this.url.build('sales/:id', {id: sale_id}).toString(false))
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
        <component-search-list :loading="loading" @search="onSearch">
            <slot name="filters">
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
                            <option value=""> Todas los métodos de pago </option>
                        </template>
                    </b-form-select>
            </slot>
        </component-search-list>
            <b-table
                striped
                hover
                :items="data"
                :fields="fields"
                @filtered="onFiltered"
                :sort-desc.sync="pagination.order"
                :sort-by.sync="pagination.order_by"
                responsive
                sort-icon-left
            >
                <template v-slot:cell(actions)="row">
                    <b-button variant="outline-dark" class="mr-1" @click="show(row.item.id)">
                        <font-awesome-icon icon="eye" />
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
    </section>
</template>