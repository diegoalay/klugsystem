<script>
import componentProductItem from 'vueApp/components/sales/product-item.vue'

export default {
    props: {
        options: {
            type: Object,
            required: true
        }
    },
    components: {
        'component-product-item': componentProductItem
    },
    data(){
        return {
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
            .filters({search: this.search_text})
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
        <component-search-list :loading="loading" @search="onSearch"/>
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
    </div>
</template>
