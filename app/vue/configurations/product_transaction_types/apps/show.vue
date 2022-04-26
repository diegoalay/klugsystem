<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                product_transaction_type: {},
                id: null
            }
        },
        mounted(){
            this.setId()
            this.getData()
        },
        methods:{
            setId(){
                this.id = this.$route.params.id

            },
            getData(){
                const url = this.url.config('product_transaction_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.product_transaction_type = result.data
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    }
</script>

<template>
    <section>
        <component-header-form
            title="Tipos de transacción de producto">
        </component-header-form>
        <component-form :product_transaction_type="product_transaction_type"></component-form>
    </section>
</template>