<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                measurement_unit: {},
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
                const url = this.url.inventory('measurement_units/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.measurement_unit = result.data
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
            title="Unidad de medida">
        </component-header-form>
        <component-form :measurement_unit="measurement_unit"></component-form>
    </section>
</template>