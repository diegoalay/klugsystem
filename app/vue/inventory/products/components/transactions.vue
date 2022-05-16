<script type="text/javascript">
    export default {
        props: {
            product: {
                type: Object,
                required: true
            }
        },
        data() {
            return {
                data: [],
                fields: [{
                    label: 'Fecha de creación',
                    key: 'created_at',
                },{
                    label: 'Usuario creador',
                    key: 'user_creator_name',
                    sortable: true
                },{
                    label: 'Tipo',
                    key: 'transaction_type',
                    sortable: true
                },{
                    label: 'Cantidad',
                    key: 'quantity',
                    sortable: true
                },{
                    label: 'Descripción',
                    key: 'description'
                },{
                    label: 'Detalles',
                    key: 'actions'
                }],
                pagination: {
                    total: 0,
                    per_page: 10,
                    current_page: 1,
                    order_by: 'created_at',
                    order: true,
                },
                search_text: '',
                loading: false,
                product_transaction: {
                    category: 'increase',
                    id: null
                },
                options: {
                    transaction_types: []
                }
            }
        },
        mounted() {
            this.getOptions()
            this.getProductTransactions()
        },
        methods: {
            onSubmit(){
                if (this.product_transaction.id) {
                    this.putForm()
                } else {
                    this.postForm()
                }
            },
            postForm(){
                const url = this.url.inventory('products/:id/transactions', {id: this.product.id})

                let form = {
                    product_transaction: this.product_transaction
                }

                this.http.post(url, form).then(result => {
                    if (result.successful) {
                        this.$toast.success('Transacción creada exitosamente.')

                        let quantity = parseFloat(this.product.quantity)

                        if (this.product_transaction.category === 'increase') {
                            quantity +=  parseFloat(this.product_transaction.quantity)
                        } else {
                            quantity -=  parseFloat(this.product_transaction.quantity)
                        }

                        this.$set(this.product, 'quantity', quantity)

                        this.getProductTransactions()
                        thiis.clearForm()
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },
            getProductTransactions(){
                this.loading = true

                const url = this.url.inventory('products/:id/transactions', {id: this.product.id})
                .filters({search: this.search_text})
                .paginate(this.pagination.current_page, this.pagination.per_page)
                .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.data = response.data.transactions
                        this.pagination.total = response.data.total_count
                    } else {
                        this.$toast.error(result.error.message)
                    }

                    this.loading = false
                }).catch(error => {
                    console.log(error)
                })
            },
            getOptions(){
                const url = this.url.inventory('products/transactions/options')

                this.http.get(url).then(response => {
                    if (response.successful) {
                        this.options = response.data
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },
            onSearch(text){
                this.search_text = text

                this.getProductTransactions()
            },
            onFiltered(filteredItems) {
                this.totalRows = filteredItems.length
                this.currentPage = 1
            },
            clearForm(){
                this.product_transaction = {
                    id: null
                }
            },
            modelDetails(details, type){
                switch(type) {
                    case 'Sale':
                        return `Venta (${this.date.datetime(details.created_at)})`
                    default:
                        return ''
                }
            },
            showDetails(transaction){
                if (!transaction.model_type) return

                const model_type = transaction.model_type
                const model_id = transaction.model_id

                switch(model_type) {
                    case 'Sale':
                        this.$router.push(this.url.finance('sales/:id', { id: model_id }).toString(false))
                    default:
                        return
                }
            }
        },

        watch: {
            'pagination.current_page'() {
                this.getProductTransactions()
            },

            'pagination.order_by'() {
                this.getProductTransactions()
            },

            'pagination.order'(){
                this.getProductTransactions()
            }
        }
    }
</script>

<template>
    <section>

        <b-form @submit.prevent="onSubmit">
            <b-row>
                <b-col md="3" sm="12">
                    <b-form-group>
                       <template #label>
                            Tipo de transacción <sup class="text-danger">*</sup>
                        </template>

                        <b-input-group>
                            <template #prepend>
                                <b-button @click="product_transaction.category = 'decrease'" v-if="product_transaction.category === 'increase'" variant="success">
                                    <font-awesome-icon icon="arrow-up" fixed-width />
                                </b-button>
                                <b-button @click="product_transaction.category = 'increase'" v-else variant="danger">
                                    <font-awesome-icon icon="arrow-down" fixed-width />
                                </b-button>
                            </template>
                            <b-form-select required v-model="product_transaction.product_transaction_type_id" :options="options.transaction_types">
                                <template #first>
                                    <b-form-select-option :value="null"> Seleccione un tipo de transacción  </b-form-select-option>
                                </template>
                            </b-form-select>
                        </b-input-group>
                    </b-form-group>
                </b-col>

                <b-col md="3" sm="12">
                    <b-form-group>
                        <template #label>
                            Cantidad <sup class="text-danger">*</sup>
                        </template>

                        <b-form-input
                            min="0"
                            :max="product_transaction.category === 'decrease' ? product.quantity : ''"
                            v-model="product_transaction.quantity"
                            type="number"
                            placeholder=""
                            required
                        >
                        </b-form-input>
                    </b-form-group>
                </b-col>

                <b-col md="5" sm="12">
                    <b-form-group>
                        <template #label>
                            Descripción
                        </template>

                        <b-form-input
                            v-model="product_transaction.description"
                            type="text"
                            placeholder=""
                        >
                        </b-form-input>
                    </b-form-group>
                </b-col>

                <b-col>
                    <b-form-group>
                       <template v-if="!tools.isMobile()" #label>
                           Guardar
                        </template>

                        <b-button type="submit" variant="primary" block>
                            <font-awesome-icon icon="floppy-disk" />
                        </b-button>
                    </b-form-group>
                </b-col>
            </b-row>
        </b-form>

        <hr>

        <component-search-list :loading="loading" @search="onSearch"/>
            <b-table
                @row-clicked="showDetails"
                striped
                hover
                :items="data"
                :fields="fields"
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

                <template v-slot:cell(quantity)="row">
                    <div v-if="row.item.category == 'decrease'" class="p-1 text-danger">
                        {{ row.item.quantity }}
                    </div>
                    <div v-else class="p-1 text-success">
                        {{  row.item.quantity }}
                    </div>
                </template>

                <template v-slot:cell(actions)="row">
                    <div v-if="row.item.model_details" class="p-1">
                        {{ modelDetails(row.item.model_details, row.item.model_type) }}
                    </div>
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
    </section>
</template>