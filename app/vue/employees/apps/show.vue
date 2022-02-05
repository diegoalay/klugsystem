<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                main_path: '/employees',
                employee: {},
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
                        this.employee = result.data
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
            title="Empleado">
        </component-header-form>
        <component-form v-if="employee.id" :main_path="main_path" :employee="employee"></component-form>
    </section>
</template>