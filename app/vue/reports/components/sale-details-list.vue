<script type="text/javascript">
import ComponentDialogDelete from 'vueApp/components/component-dialog-delete.vue'
import componenSaleEmails from 'vueApp/components/sales/component-sale-emails.vue'

export default {
    props: {
        app_module: {
            require: true,
            type: String
        },
        cashRegisterId: {
            type: Number,
            default: null
        },
        hideHeader: {
            type: Boolean,
            default: false
        },
        dateRange: {
            type: Array,
            default: null
        },
        initFilters: {
            type: Object,
            default: () => {}
        }
    },
    components: {
        'component-sale-emails': componenSaleEmails
    },
    data() {
        return {
            data: [],
            fields: [{
                label: 'Fecha',
                key: 'created_at',
                sortable: true
            },{
                label: 'Nombre',
                key: 'name',
                sortable: true
            },{
                label: 'Cantidad',
                key: 'quantity',
                sortable: true
            },{
                label: 'Subtotal',
                key: 'subtotal',
                sortable: true
            },{
                label: 'Intéres',
                key: 'interest_value',
                sortable: true
            },{
                label: 'Subtotal',
                key: 'subtotal_1',
                sortable: true
            },{
                label: 'Descuento',
                key: 'discount_value',
                sortable: true
            },{
                label: 'Total',
                key: 'total',
                sortable: true
            }],
            pagination: {
                total: 0,
                per_page: 10,
                current_page: 1,
                order_by: 'created_at',
                order: true,
            },
            options: {
                payment_methods: [],
                sale_types: []
            },
            filters: {
                search: '',
                product_type: '',
                user_creator_type: '',
                date_range: this.dateRange ? this.dateRange : []
            },
            sale: {},
            loading: false,
            timer: null
        }
    },
    mounted() {
        this.addUserCreatorColumn()
        this.list()
        this.getOptions()

        for(let key in this.filters) {
            if (key === 'date_range' && this.initFilters[key]) {
                this.$set(this.filters, key, [
                    new Date(this.initFilters[key][0]),
                    new Date(this.initFilters[key][1]),
                ])
            } else if (this.initFilters[key]) {
                this.$set(this.filters, key, this.initFilters[key])
            }
        }
    },
    methods: {
        list(){
            clearTimeout(this.timer)
            this.timer = setTimeout(() => {
                this.loading = true

                let filters = null

                if (this.filters.date_range.length > 0){
                    filters = {
                        ...this.filters,
                        start_date: this.filters.date_range[0] ?
                            this.filters.date_range[0].toISOString() :
                            '',
                        end_date: this.filters.date_range[1] ?
                            this.filters.date_range[1].toISOString() :
                            ''
                    }
                } else {
                    filters = this.filters
                }

                const url = this.url[this.app_module]('sale_details')
                .filters(filters)
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.records
                        this.pagination.total = response.data.total_count

                        this.$emit('change', filters)
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            }, 200)
        },

        addUserCreatorColumn(){
            this.fields.splice(this.fields.length, 0, {
                label: 'Usuario creador',
                key: 'user_creator_name',
                sortable: true
            })
        },

        getOptions(){
            const url = this.url[this.app_module]('sale_details/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data

                    if (this.cashRegisterId || this.app_module === 'reports' || this.app_module === 'pos') {
                        const user_creator_types = this.options.user_creator_types.filter(e => e.value !== 'current_cash_register')

                        this.$set(this.options, 'user_creator_types', user_creator_types)
                    }
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        show(sale){
            if (this.app_module === 'reports') return

            this.$router.push(this.url[this.app_module]('sales/:id', {id: sale.id}).toString(false))
        },

        sendSale(sale){
            this.sale = sale
            this.$bvModal.show('emails')
        },

        onSearch(text){
            this.filters.search = text

            this.list()
        },

        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length
            this.currentPage = 1
        },

        subtotal1(sale_detail){
            return parseFloat(
                parseFloat(sale_detail.subtotal) + parseFloat(sale_detail.interest_value)
            ).toFixed(2)
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
        },

        'filters.date_range'(){
            this.list()
        },
    }
}
</script>

<template>
    <section>
        <b-card>
            <component-search-list :default-value="filters.search" :loading="loading" @search="onSearch">
                <slot name="filters">
                    <b-form-select
                        v-model="filters.user_creator_type"
                        :options="options.user_creator_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todas las ventas </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <b-form-select
                        v-model="filters.product_type"
                        :options="options.product_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Bien y Servicio </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                    <component-datepicker
                        v-if="dateRange"
                        v-model="filters.date_range"
                        lang="es"
                        format="DD-MM-YYYY"
                        range
                        placeholder="Seleccione un rango de fechas"
                    >
                    </component-datepicker>
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

                    <template v-slot:cell(created_at)="row">
                        {{ date.datetime(row.item.created_at) }}
                    </template>

                    <template v-slot:cell(interest_value)="row">
                        {{ row.item.interest_value > 0 ? row.item.interest_value + ` (${row.item.interest_percentage} %)` : '-'}}
                    </template>

                    <template v-slot:cell(discount_value)="row">
                        {{ row.item.discount_value > 0 ? row.item.discount_value + ` (${row.item.discount_percentage} %)` : '-' }}
                    </template>

                    <template v-slot:cell(subtotal_1)="row">
                        {{ subtotal1(row.item) }}
                    </template>

                    <template v-slot:cell(sale_type)="row">
                        {{ row.item.sale_type_text }}
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