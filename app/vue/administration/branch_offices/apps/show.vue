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
                main_path: '/branch_offices',
                branch_office: {},
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
                const url = this.url.build('branch_offices/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.branch_office = result.data
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
            title="Sucursales">
        </component-header-form>
        <component-form :main_path="main_path" :branch_office="branch_office"></component-form>
    </section>
</template>