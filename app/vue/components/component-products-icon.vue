<script>
import componentProductItem from 'vueApp/components/sales/product-item.vue'
import componentProductForm from 'vueApp/inventory/products/components/form.vue'

export default {
    props: {
        options: {
            type: Object,
            required: true
        }
    },
    components: {
        'component-product-item': componentProductItem,
        'component-product-form': componentProductForm
    },
    data(){
        return {
            newProduct: {
                id: null,
                product_type: 'good'
            },
            products: [],
            loading: false,
            search_text: '',
            pagination: {
                total: 0,
                per_page: 9,
                current_page: 1,
                order_by: 'name',
                order: false,
            }
        }
    },
    mounted(){
        if (this.tools.isMobile()) {
            this.pagination.per_page = 2
        }

        this.getProducts()
    },
    methods: {
        getProducts(){
            const url = this.url.inventory('products')
            .filters({search: this.search_text, view_type: 'sale'})
            .paginate(this.pagination.current_page, this.pagination.per_page)
            .order(this.pagination.order_by, this.pagination.order ? 'desc' : 'asc')

            this.loading = true
            this.http.get(url).then(response => {
                if (response.successful) {
                    this.products = response.data.products
                    this.pagination.total = response.data.total_count
                } else {
                    this.$toast.error(response.error.message)
                }

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },

        onSearch(text){
            this.search_text = text

            this.getProducts()
        },

        addProduct(product){
            this.$emit('addProduct', product)
        },

        addNewProduct(){
            this.$bvModal.show('product-form')
        },

        productPosted(product){
            this.pagination.total += 1
            this.products.unshift(product)
            this.newProduct = {
                id: null,
                product_type: 'good'
            }

            this.$bvModal.hide('product-form')
        }
    },
    watch: {
        'pagination.current_page'() {
            this.getProducts()
        },

        'pagination.order_by'() {
            this.getProducts()
        },

        'pagination.order'(){
            this.getProducts()
        }
    }
}
</script>

<template>
    <div>
        <br>
        <b-row>
            <b-col>
                <component-search-list :loading="loading" @search="onSearch"/>
            </b-col>
            <b-col md="3" sm="4">
                <b-button
                    @click="addNewProduct"
                    variant="primary"
                    data-toggle="tooltip"
                    data-placement="top"
                    title="Agregar un producto nuevo"
                >
                    Nuevo <font-awesome-icon icon="plus" />
                </b-button>
            </b-col>
        </b-row>
        <hr>
        <b-row>
            <component-product-item
                :options="options"
                v-for="product in products"
                :key="product.id"
                :product="product"
                @product="addProduct"
            >
            </component-product-item>
        </b-row>
        <br>
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

        <b-modal
            id="product-form"
            size="xl"
            centered
            hide-footer
            content-class="shadow"
            title="Nuevo producto / servicio"
        >
            <component-product-form
                :showProduct="false"
                :product="newProduct"
                @post="productPosted"
            >
            </component-product-form>
        </b-modal>
    </div>
</template>