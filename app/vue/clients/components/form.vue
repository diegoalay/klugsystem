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
                this.putForm()
            } else {
                this.postForm()
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
                    // this.notification('creado exitosamente.')
                } else {
                    // this.notification(result.data.message.errors)
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
                    // this.notification('actualizado exitosamente.')
                } else {
                    // this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        exportCsv(){

        }
    }
}
</script>

<template>
    <b-form @submit.prevent="onSubmit">
        <b-card>
            <b-card-body>
                <b-container>
                    <b-row>
                        <b-col cols="8">
                            <p class="col-header">
                                Información general
                            </p>

                            <b-form-group>
                                <label> Nombre <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="client.first_name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group>
                                <label> Apellido<sup class="text-danger">*</sup> </label>
                                <b-form-input
                                    v-model="client.last_name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
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

                            <b-form-group label="Nota">
                                <b-form-textarea
                                    v-model="client.note"
                                    placeholder="Ingrese observaciones"
                                    rows="3"
                                >
                                </b-form-textarea>
                            </b-form-group>

                        </b-col>
                        <b-col>
                            <p class="col-header">
                                Información de contacto
                            </p>
                            <b-form-group label="Teléfono">
                                <b-form-input
                                    v-model="client.telephone"
                                    type="text"
                                    placeholder=""
                                    >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Celular">
                                <b-form-input
                                    v-model="client.mobile_number"
                                    type="text"
                                    placeholder="">
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="E-Mail">
                                <b-form-input
                                    v-model="client.email"
                                    type="email"
                                    placeholder="">
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Fax">
                                <b-form-input
                                    v-model="client.fax"
                                    type="text"
                                    placeholder="">
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>
                </b-container>
                <b-container>
                    <b-row>
                        <b-col>
                            <p class="col-header">
                                Información de facturación
                            </p>

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

                            <b-form-group label="E-Mail de facturación">
                                <b-form-input
                                    v-model="client.billing_email"
                                    type="email"
                                    placeholder=""
                                    >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>
                </b-container>
                <br>
                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button type="reset" variant="outline-dark">Limpiar</b-button>
                    <b-button variant="outline-dark" v-if="client.id">Exportar CSV</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>