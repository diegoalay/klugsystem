<script>

export default {
    props: {
        client: {
            required: true,
            type: Object
        }
    },
    components: {

    },
    data() {
        return {
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
            const url = this.url.crm('clients')
            let form = {
                client: this.client
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Cliente creado exitosamente.')
                    this.$router.push(this.url.crm('clients/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.crm('clients/:id', {id: this.client.id})

            let form = {
                client: this.client
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Cliente actualizado exitosamente.')
                } else {
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
    <b-form @submit.prevent="onSubmit">
        <b-card>
            <b-card-body>
                <b-row>
                    <b-col>
                        <p class="col-header">
                            Información de facturación
                        </p>

                        <b-form-group>
                            <label> Nit <sup class="text-danger">*</sup> </label>
                            <b-form-input
                                v-model="client.billing_identifier"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Nombre de facturación <sup class="text-danger">*</sup> </label>
                            <b-form-input
                                v-model="client.billing_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Dirección de facturación <sup class="text-danger">*</sup> </label>
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
                <hr>
                <b-row>
                    <b-col md="8" sm="12">
                        <p class="col-header">
                            Información general
                        </p>

                        <b-form-group>
                            <label> Nombre </label>

                            <b-form-input
                                v-model="client.first_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Apellido </label>
                            <b-form-input
                                v-model="client.first_surname"
                                type="text"
                                placeholder=""
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
                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>