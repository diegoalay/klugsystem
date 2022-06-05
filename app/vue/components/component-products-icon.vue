<script>
import componentProductItem from 'vueApp/components/sales/product-item.vue'

export default {
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
                per_page: 20,
                current_page: 1,
                order_by: 'quantity',
                order: true,
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
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.products = result.data.products
                } else {
                    this.$toast.error(result.error.message)
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
                v-for="product in products"
                :key="product.id"
                :product="product"
                @product="addProduct"
            >
            </component-product-item>
        </b-row>
    </div>
</template>
