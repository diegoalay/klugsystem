<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        props: {
        },
        data() {
            return {
                provider: {},
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
                const url = this.url.purchases('providers/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.provider = result.data
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
            title="Proveedores">
        </component-header-form>
        <component-form :provider="provider"></component-form>
    </section>
</template>