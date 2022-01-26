<script>
export default {
    props: {
        client: {
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
            if (this.client.id) {
                this.postForm()
            } else {
                this.putForm()
            }
        },
        postForm(){
            let url = `${this.main_path}.json`
            let form = {
                client: this.client
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
            let url = `${this.main_path}/${this.client.id}.json`
            let form = {
                client: this.client
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
                        v-model="client.first_name"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Apellido(s)">
                    <b-form-input
                        v-model="client.last_name"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Teléfono">
                    <b-form-input
                        v-model="client.telephone"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="E-Mail">
                    <b-form-input
                        v-model="client.email"
                        type="email"
                        placeholder="">
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Fecha de nacimiento">
                    <component-datepicker
                        :focus="false"
                        lang="es"
                        valueType="format"
                        format="DD-MM-YYYY"
                        v-model="client.birthdate"
                        placeholder="">
                    </component-datepicker>
                </b-form-group>

                <b-form-group label="Nit">
                    <b-form-input
                        v-model="client.billing_identifier"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Nombre de facturación">
                    <b-form-input
                        v-model="client.billing_name"
                        type="text"
                        placeholder=""
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Dirección de facturación">
                    <b-form-input
                        v-model="client.billing_address"
                        type="text"
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