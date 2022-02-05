<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'SKU',
                    key: 'sku',
                    sortable: true
                },{
                    label: 'Nombre',
                    key: 'name',
                    sortable: true
                },{
                    label: 'Precio',
                    key: 'retail_price',
                    sortable: true
                },{
                    label: 'Precio mayoreo',
                    key: 'wholesale_price',
                    sortable: true
                },{
                    label: 'Cantidad',
                    key: 'quantity',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'name',
                    order: false,
                },
                search_text: '',
                main_path: '/products',
                loading: false
            }
        },
        mounted() {
            this.list()
        },
        methods: {
            list(){
                this.loading = true

                const order = this.pagination.order ? 'desc' : 'asc'
                let url = `${this.main_path}.json?`
                url += `filters[search]=${this.search_text}`
                url += `&current_page=${this.pagination.current_page}&per_page=${this.pagination.per_page}`
                url += `&order_by=${this.pagination.order_by}&order=${order}`

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.products
                        this.pagination.total = response.data.total_count
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            show(product){
                this.$router.push(`/${product.id}`)
            },
            deleteRecord(id){
                let url = `${this.main_path}/${id}.json`
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.data = this.data.filter(e => e.id !== id)
                        this.pagination.total -= 1
                        // this.notification('eliminado exitosamente.')
                    } else {
                        // this.notification(result.message.error)
                    }
                }).catch(error => {
                    console.log(error)
                })
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
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-list
            title="Productos"
            title-button-create="Agregar producto"
            :loading="loading"
            @reloadList="list"
        >
        </component-header-list>

        <b-card>
            <component-search-list :loading="loading" @search="onSearch"/>
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
                    responsive="sm"
                    sort-icon-left
                >
                    <template v-slot:cell(actions)="row">
                        <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
                            <b-icon icon="trash-fill"></b-icon>
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