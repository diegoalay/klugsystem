<script type="text/javascript">
    export default {
        props: {
            cash_register: {
                required: true,
                type: Object
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
                search_text: '',
                filters: {
                    expediture_type: ''
                },
                loading: false,
                options: []
            }
        },
        mounted() {
            this.getOptions()
            this.list()
        },
        methods: {
            getOptions(){
                const url = this.url.build('expeditures/options')

                this.http.get(url).then(response => {
                    this.options = response.data
                }).catch(error => {
                    console.log(error)
                })
            },
            list(){
                this.loading = true
                const url = this.url.build('expeditures')
                .filters({
                    ...this.filters,
                    cash_register_id: this.cash_register.id
                })

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
                this.$router.push(this.url.build('expeditures/:id', {id: expediture.id}).toString(false))
            },
            deleteRecord(id){
                const url = this.url.build('expeditures/:id', {id: id})
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
            </slot>
        </component-search-list>
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
            responsive
        >
            <template v-slot:cell(actions)="row" v-if="!cash_register.closed">
                <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
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
    </section>
</template>