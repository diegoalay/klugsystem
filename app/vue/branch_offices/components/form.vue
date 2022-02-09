<script>
export default {
    props: {
        branch_office: {
            required: true,
            type: Object
        }
    },
    components: {},
    data() {
        return {

        }
    },
    mounted() {},
    methods: {
        onSubmit(){
            if (this.branch_office.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('branch_offices')
            let form = {
                branch_office: this.branch_office
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Sucursal creada exitosamente.')
                    this.$router.push(`/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('branch_offices/:id', {id: this.branch_office.id})
            let form = {
                branch_office: this.branch_office
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Sucursal actualizada exitosamente.')
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
                <b-container>
                    <b-row>
                        <b-col>
                            <p class="col-header">
                                Información general
                            </p>

                            <b-form-group>
                                <label> Nombre <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="branch_office.name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group>
                                <label> Teléfono <sup class="text-danger">*</sup> </label>
                                <b-form-input
                                    v-model="branch_office.telephone"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Postcode">
                                 <b-form-input
                                    v-model="branch_office.postcode"
                                    type="text"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Direción">
                                 <b-form-input
                                    v-model="branch_office.street_address"
                                    type="text"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Nombre de la calle">
                                 <b-form-input
                                    v-model="branch_office.street_name"
                                    type="text"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>

                            <b-form-group label="Número de calle">
                                 <b-form-input
                                    v-model="branch_office.street_number"
                                    type="text"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>
                </b-container>
                <b-container>
                    <b-row>
                        <b-col>
                            <p class="col-header">
                                Información de facturación Electrónica
                            </p>

                            <b-form-group label="Facturación electrónica">
                                <b-form-checkbox
                                    v-model="branch_office.electronic_billing"
                                >
                                    {{ branch_office.electronic_billing ? 'Deshabilitar' : 'Habilitar'}}
                                </b-form-checkbox>
                            </b-form-group>

                            <b-form-group label="Código de establecimiento">
                                <b-form-input
                                    v-model="branch_office.billing_identifier"
                                    type="text"
                                    placeholder=""
                                    :required="branch_office.electronic_billing"
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
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>