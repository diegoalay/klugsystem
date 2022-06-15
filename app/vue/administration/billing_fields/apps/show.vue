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
                billing_field: {},
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
                const url = this.url.admin('billing_fields/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.billing_field = result.data
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
    <section>
        <component-header-form
            title="Campo de facturación">
        </component-header-form>
        <component-form :billing_field="billing_field"></component-form>
    </section>
</template>