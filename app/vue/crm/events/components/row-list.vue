<script type="text/javascript">
    export default {
        props: {
            endPoint: {
                default: 'crm/events'
            },

            reload: {
                type: Boolean,
                required: true
            }
        },

        data() {
            return {
                data: [],
                fields: [{
                    label: 'Título',
                    key: 'title',
                    sortable: true
                },{
                    label: 'Asignado',
                    key: 'model_identifier',
                    sortable: true
                },{
                    label: 'Fecha',
                    key: 'date',
                    sortable: true
                },{
                    label: 'Inicio',
                    key: 'time_start',
                    sortable: true
                },{
                    label: 'Termina',
                    key: 'time_end',
                    sortable: true
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'title',
                    order: false,
                },
                search_text: '',
                loading: false
            }
        },
        mounted() {
            this.list()
        },
        methods: {
            list(){
                this.loading = true

                const url = this.url.build(this.endPoint)
                .filters({search: this.search_text})
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.records
                        this.pagination.total = response.data.total_count
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            show(event){
                this.$emit('show', event)
            },
            onSearch(text){
                this.search_text = text

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
            },

            reload(){
                this.list()
            }
        }
    }
</script>

<template>
    <section>
        <b-card>
            <component-search-list :loading="loading" @search="onSearch"/>
            <b-card-body>
                <b-table
                    striped
                    hover
                    :items="data"
                    :fields="fields"
                    :sort-desc.sync="pagination.order"
                    :sort-by.sync="pagination.order_by"
                    @row-clicked="show"
                    responsive
                >

                    <template v-slot:cell(date)="row">
                        {{ date.date(row.item.date) }}
                    </template>

                    <template v-slot:cell(time_start)="row">
                        {{ date.time(row.item.time_start) }}
                    </template>

                    <template v-slot:cell(time_end)="row">
                        {{ date.time(row.item.time_end) }}
                    </template>
                    
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((pagination.order) && (pagination.order_by === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!pagination.order) && (pagination.order_by === key))" icon="sort-up" />
                            </template>
                        </template>
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
                    >
                    </b-pagination>
                </b-col>
            </b-card-body>
        </b-card>
    </section>
</template>