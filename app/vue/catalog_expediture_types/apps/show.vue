<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_expediture_type: {},
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
                const url = this.url.build('catalog/expediture_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.catalog_expediture_type = result.data
                    }else{
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
            title="Tipos de gasto">
        </component-header-form>
        <component-form :catalog_expediture_type="catalog_expediture_type"></component-form>
    </section>
</template>