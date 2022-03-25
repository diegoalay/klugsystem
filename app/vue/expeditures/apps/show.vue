<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                expediture: {},
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
                const url = this.url.build('expeditures/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.expediture = {
                            ...result.data,
                            expediture_date: result.data.expediture_date ?
                                new Date(result.data.expediture_date) :
                                null
                        }
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
            title="Gastos">
        </component-header-form>
        <component-form :expediture="expediture"></component-form>
    </section>
</template>