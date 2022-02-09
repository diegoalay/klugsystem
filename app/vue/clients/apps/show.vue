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
                main_path: '/clients',
                client: {},
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
                const url = this.url.build('departments/:id', {id: id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.client = result.data
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
            title="Clientes">
        </component-header-form>
        <component-form :main_path="main_path" :view_type="view_type" :client="client"></component-form>
    </section>
</template>