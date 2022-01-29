<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                main_path: '/departments',
                department: {},
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
                let url = `${this.main_path}/${this.id}.json?`
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.department = result.data
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
            title="Departamentos">
        </component-header-form>
        <component-form :main_path="main_path" :department="department"></component-form>
    </section>
</template>