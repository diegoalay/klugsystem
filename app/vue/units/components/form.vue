<script>
export default {
    props: {
        unit: {
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
                title: 'Unidades:'
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
                unit: this.unit
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
            let url = `${this.main_path}/${this.unit.id}.json`
            let form = {
                unit: this.unit
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
                <b-form-group label="Unidad">
                    <b-form-input
                        v-model="unit.alias"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Marca">
                    <b-form-input
                        v-model="unit.brand"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Placa">
                    <b-form-input
                        v-model="unit.plate"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Modelo">
                    <b-form-input
                        v-model="unit.model"
                        type="number"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>
                
                <b-button type="submit" variant="primary">Guardar</b-button>
                <b-button type="reset" variant="default">Limpiar</b-button>
            </b-form>
            <notifications group="foo" />
        </b-card-body>
    </b-card>
</template>