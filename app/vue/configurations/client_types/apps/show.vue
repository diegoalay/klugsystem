<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                client_type: {},
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
                const url = this.url.config('client_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.client_type = result.data
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
            title="Tipos de clientes">
        </component-header-form>
        <component-form :client_type="client_type"></component-form>
    </section>
</template>