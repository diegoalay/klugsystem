<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Usuario',
                    key: 'user_creator_name',
                    sortable: true
                },{
                    label: 'Fecha de apertura',
                    key: 'open_date',
                    sortable: true
                },{
                    label: 'Fecha de cierre',
                    key: 'close_date',
                    sortable: true
                },{
                    label: 'Valor inicial',
                    key: 'initial_value',
                    sortable: true
                },{
                    label: 'Valor final',
                    key: 'final_value',
                    sortable: true
                },{
                    label: 'Usuario creador',
                    key: 'user_creator_name',
                    sortable: true
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'open_date',
                    order: true,
                },
                options: {
                    cash_register_statuses: [
                        {text: 'Abierta', value: 'open'},
                        {text: 'Cerrada', value: 'close'}
                    ]
                },
                filters: {
                    search: '',
                    date_range: ['', ''],
                    cash_register_status: ''
                },
                loading: false
            }
        },
        mounted() {
            this.list()
        },
        methods: {
            list(){
                this.loading = true

                const url = this.url.build('cash_registers')
                .filters({
                    search: this.filters.search,
                    start_date: this.filters.date_range[0] ?
                        this.filters.date_range[0].toString() :
                        '',
                    end_date: this.filters.date_range[1] ?
                        this.filters.date_range[1].toString() :
                        '',
                    cash_register_status: this.filters.cash_register_status
                })
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.cash_registers
                        this.pagination.total = response.data.total_count
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },

            getOptions(){
                const url = this.url.build('cash_registers/index_options')

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

            show(cash_register){
                this.$router.push(this.url.build('cash_registers/:id', {id: cash_register.id}).toString(false))
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
            'filters.date_range'(){
                this.list()
            },

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
    <section class="application-component">
        <component-header-list
            :hide-creation-button="true"
            title="Listado de cajas"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch">
                <slot name="filters">
                    <component-datepicker
                        v-model="filters.date_range"
                        lang="es"
                        format="DD-MM-YYYY"
                        range
                        placeholder="Seleccione un rango de fechas"
                    >
                    </component-datepicker>
                        &nbsp;
                    <b-form-select
                        v-model="filters.cash_register_status"
                        :options="options.cash_register_statuses"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Estado de la caja </option>
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
                    sort-icon-left
                >
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