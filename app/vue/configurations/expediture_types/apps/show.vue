<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                expediture_type: {},
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
                const url = this.url.config('expediture_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.expediture_type = result.data
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
        <component-form :expediture_type="expediture_type"></component-form>
    </section>
</template>