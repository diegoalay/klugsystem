<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_client_type: {},
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
                console.log(this.id)
            },
            getData(){
                const url = this.url.build('catalog/client_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.catalog_client_type = result.data
                    }else{

                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Tipos de clientes">
        </component-header-form>
        <component-form :catalog_client_type="catalog_client_type"></component-form>
    </section>
</template>