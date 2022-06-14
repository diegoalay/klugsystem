<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Fecha',
                    key: 'quotation_date',
                    sortable: true
                },{
                    label: 'Cliente',
                    key: 'client_name',
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
                    order_by: 'quotation_date',
                    order: true,
                },
                options: {
                    payment_methods: [],
                    quotation_types: []
                },
                filters: {
                    search: '',
                    quotation_type: '',
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

                const url = this.url.finance('quotations')
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

            async deleteQuotation(quotation_id){
                const resp = await this.$dialog.confirm(
                    {
                        title: '¿Esta seguro que desea eliminar la cotización?',
                        text: 'Esta acción eliminará la cotización del sistema.',
                        actions: [
                            {
                                text: 'Confirmar',
                                color: 'success',
                                key: true,
                            },
                            {
                                text: 'Cancelar',
                                color: 'danger',
                                key: false,
                            },
                        ]
                    }
                )

                if (resp) {
                    const url = this.url.finance('quotations/:id', {id: quotation_id})
                    this.http.delete(url).then(result => {
                        if (result.successful) {
                            this.$toast.success('Cotización eliminada exitosamente.')

                            this.data = this.data.filter(e => e.id !== quotation_id)
                        } else {
                            this.$toast.error(result.error.message)
                        }
                    }).catch(error => {
                        console.log(error)
                    })
                }
            },

            getOptions(){
                const url = this.url.finance('quotations/options').filters({action: 'index'})

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

            show(quotation){
                this.$router.push(this.url.finance('quotations/:id', {id: quotation.id}).toString(false))
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
            title="Cotizaciones"
            title-button-create="Cotizar"
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

                    <template v-slot:cell(quotation_date)="row">
                        {{ date.datetime(row.item.created_at) }}
                    </template>

                    <template v-slot:cell(actions)="row">
                        <b-button @click="tools.printQuotation(row.item.id)" variant="outline-dark" class="mr-1">
                            <font-awesome-icon icon="print" />
                        </b-button>

                        <b-button @click="deleteQuotation(row.item.id)" variant="outline-danger" class="mr-1">
                            <font-awesome-icon icon="xmark" />
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