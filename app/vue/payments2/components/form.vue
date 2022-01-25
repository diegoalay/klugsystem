<script>
export default {
    props: {
        pilot: {
            required: true,
            type: Object
        },
        view_type: {
            default: 'new'
        },
        main_path: {
            required: true
        }
    },
    components: {

    },
    data() {
        return {
            options: {
                truck_types: []   
            },
            alert: {
                title: 'Pilotos:'
            }
        }
    },
    mounted() {

    },
    methods: {
        onSubmit(){
            if (this.view_type === 'new') {
                this.postForm()
            } else {
                this.putForm()
            }
        },
        postForm(){
            let url = `${this.main_path}.json`
            let form = {
                pilot: this.pilot
            }
            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$router.push(`/${result.data.id}`)
                    this.notification('creado exitosamente.')
                } else {
                    this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            let url = `${this.main_path}/${this.pilot.id}.json`
            let form = {
                pilot: this.pilot
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.notification('actualizado exitosamente.')
                } else {
                    this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        notification(text, type = "success"){
            this.$notify({
                groups: "foo",
                title: this.alert.title,
                type,
                text
            })
        },
    }
}
</script>

<template>
    <b-card>    
        <b-card-body>
            <b-form @submit.prevent="onSubmit">
                <b-form-group label="Nombre(s)">
                    <b-form-input
                        v-model="pilot.first_name"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Apellido(s)">
                    <b-form-input
                        v-model="pilot.last_name"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="DPI">
                    <b-form-input
                        v-model="pilot.dpi"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Salario">
                    <b-form-input
                        v-model="pilot.salary"
                        type="number"
                        placeholder="">
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Fecha inicio">
                    <component-datepicker
                        :focus="false"
                        lang="es"
                        valueType="format" 
                        format="DD-MM-YYYY"
                        v-model="pilot.start_date"
                        placeholder="">
                    </component-datepicker>
                </b-form-group>
        
                <b-form-group label="Fecha Final">
                    <component-datepicker
                        :focus="false"
                        lang="es"
                        valueType="format" 
                        format="DD-MM-YYYY"
                        v-model="pilot.end_date"
                        placeholder="">
                    </component-datepicker>
                </b-form-group>
                
                <b-button type="submit" variant="primary">Guardar</b-button>
                <b-button type="reset" variant="default">Limpiar</b-button>
            </b-form>
            <notifications group="foo" />
        </b-card-body>
    </b-card>
</template>