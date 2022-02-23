<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                employee: {},
                id: null,
                tabIndex: 0
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
                const url = this.url.build('employees/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.employee = result.data
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
    <section class="application-component">
        <component-header-form
            title="Empleado">
        </component-header-form>
        <b-card no-body>
            <b-tabs card pills fill v-model="tabIndex">
                <b-tab title="Formulario" fill>
                    <component-form v-if="employee.id" :employee="employee"></component-form>
                </b-tab>
                <b-tab title="Archivos" fill>
                    <component-files v-if="employee.id" default-file-key="employee" :has-picture="true" :file-id="employee.employee_file_id" :url="url.build('employees/:id/files', {id: this.employee.id}).toString(false)"> </component-files>
                </b-tab>
            </b-tabs>
        </b-card>
    </section>
</template>