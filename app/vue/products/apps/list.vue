<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Imágen',
                    key: 'thumbnail',
                },{
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
                    label: 'Estado',
                    key: 'status',
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
                loading: false
            }
        },
        mounted() {
            this.list()
        },
        methods: {
            list(){
                this.loading = true

                const url = this.url.build('products')
                .filters({search: this.search_text})
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.products
                        this.pagination.total = response.data.total_count
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            show(product){
                this.$router.push(this.url.build('products/:id', {id: product.id}).toString(false))
            },
            deleteRecord(id){
                const url = this.url.build('products/:id', {id: id})
                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.$toast.success('Producto eliminado exitosamente.')
                        this.list()
                    } else {
                        this.$toast.error(result.error.message)
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
            },
            getProductImage(product){
                if (product.product_file_id) {
                    const url = this.url.build('products/:product_id/files/:id',
                        {
                            product_id: product.id,
                            id: product.product_file_id,
                        }
                    ).toString(false)

                    return url
                }

                return this.tools.getProductImage()
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
                    :sort-desc.sync="pagination.order"
                    :sort-by.sync="pagination.order_by"
                    @row-clicked="show"
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

                    <template v-slot:cell(thumbnail)="row">
                        <b-img :src="getProductImage(row.item)" width="50" rounded alt="image"> </b-img>
                    </template>

                    <template v-slot:cell(status)="row">
                        <div v-if="row.item.quantity <= 0" class="p-1 text-danger">
                            {{ row.item.status }}
                        </div>
                        <div v-else class="p-1 text-success">
                            {{  row.item.status }}
                        </div>
                    </template>

                    <template v-slot:cell(actions)="row">
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
                    >
                    </b-pagination>
                </b-col>
            </b-card-body>
        </b-card>
    </section>
</template>