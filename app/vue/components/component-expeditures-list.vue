<script type="text/javascript">
    export default {
        props: {
            cashRegisterId: {
                type: Number,
                default: null
            },
            validateCashRegister: {
                type: Boolean,
                default: false
            }
        },
        data() {
            return {
                data: [],
                expeditures: [],
                fields: [{
                    label: 'Fecha de gasto',
                    key: 'expediture_date',
                    sortable: true
                },{
                    label: 'Description',
                    key: 'description',
                    sortable: true
                },{
                    label: 'Tipo de gasto',
                    key: 'expediture_type_name',
                    sortable: true
                },{
                    label: 'Monto',
                    key: 'amount',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1
                },
                sorting: {
                    desc: true,
                    column: 'expediture_date'
                },
                search_text: '',
                filters: {
                    expediture_type: ''
                },
                loading: false,
                options: []
            }
        },
        mounted() {
            if (this.app_module ===  'finance'){
                this.fields.push({
                    label: 'Usuario creador',
                    key: 'user_creator_name',
                    sortable: true
                })
            } else if (this.app_module === 'pos'){
                if (this.store.global.cash_register.id) {
                    this.$set(this.filters, 'user_creator_type', 'current_cash_register')

                } else {
                    const url = this.url[this.app_module]('cash_register').toString(false)

                    this.$router.push(url)

                    return
                }
            }

            if (this.cashRegisterId) {
                this.$set(this.filters, 'cash_register_id', this.cashRegisterId)
            }

            if ((this.store.global.cash_register.id) || (!this.validateCashRegister)) {
                if (this.validateCashRegister) {
                    this.$set(this.filters, 'user_creator_type', 'current_cash_register')
                }

                this.getOptions()
                this.list()
            } else {
                const url = this.url.pos('cash_register').toString(false)
                this.$router.push(url)
            }
        },
        methods: {
            getOptions(){
                const url = this.url.finance('expeditures/index_options')

                this.http.get(url).then(response => {
                    this.options = response.data
                }).catch(error => {
                    console.log(error)
                })
            },
            list(){
                this.loading = true
                const url = this.url.finance('expeditures')
                .filters(this.filters)

                this.http.get(url).then(response => {
                    this.data = response.data
                    this.pagination.total = response.data.length
                    this.expeditures = this.data
                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            show(expediture){
                this.$router.push(this.url.finance('expeditures/:id', {id: expediture.id}).toString(false))
            },
            deleteRecord(id){
                const url = this.url.finance('expeditures/:id', {id: id})
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.data = this.data.filter(e => e.id !== id)
                        this.expeditures = this.data
                        this.pagination.total -= 1
                        this.$toast.success('Gasto eliminado exitosamente.')
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },
            onSearch(text){
                this.search_text = text
            },
            onFiltered(filteredItems) {
                this.totalRows = filteredItems.length
                this.currentPage = 1
            }
        }
    }
</script>

<template>
    <section>
        <component-header-list
            v-if="!cashRegisterId"
            title="Gastos"
            title-button-create="Agregar gasto"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch">
                <slot name="filters">
                    <b-form-select
                        v-model="filters.expediture_type"
                        :options="options.expediture_types"
                        @change="list()"
                    >
                        <template #first>
                            <option value=""> Todos los tipo de gasto </option>
                        </template>
                    </b-form-select>
                    &nbsp;
                </slot>
            </component-search-list>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="expeditures"
                    :fields="fields"
                    :current-page="pagination.current_page"
                    :per-page="pagination.per_page"
                    :filter="search_text"
                    @filtered="onFiltered"
                    @row-clicked="show"
                    :sort-desc.sync="sorting.desc"
                    :sort-by.sync="sorting.column"
                    responsive
                >
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((sorting.desc) && (sorting.column === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!sorting.desc) && (sorting.column === key))" icon="sort-up" />
                            </template>
                        </template>
                    </template>

                    <template v-slot:cell(expediture_date)="row">
                        {{ date.datetime(row.item.expediture_date) }}
                    </template>

                    <template v-slot:cell(actions)="row">
                        <b-button v-if="store.global.cash_register.id && row.item.id === store.global.cash_register.id" variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
                            <font-awesome-icon icon="trash" />
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