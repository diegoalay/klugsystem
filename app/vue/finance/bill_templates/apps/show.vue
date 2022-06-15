<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                bill_template: {},
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
                const url = this.url.finance('bill_templates/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.bill_template = result.data
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
            title="Plantilla de facturación">
        </component-header-form>
        <component-form :bill_template="bill_template"></component-form>
    </section>
</template>