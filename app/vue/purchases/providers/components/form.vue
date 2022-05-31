<script>

export default {
    props: {
        provider: {
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
            if (this.provider.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.purchases('providers')
            let form = {
                provider: this.provider
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Cliente creado exitosamente.')
                    this.$router.push(this.url.purchases('providers/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.purchases('providers/:id', {id: this.provider.id})

            let form = {
                provider: this.provider
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
                    <b-col md="12" sm="12">
                        <p class="col-header">
                            Información general
                        </p>

                        <b-form-group>
                            <template #label>
                                <label> Nombre de empresa <sup class="text-danger">*</sup> </label>
                            </template>

                            <b-form-input
                                v-model="provider.company_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                <label> Teléfono <sup class="text-danger">*</sup> </label>
                            </template>
                            <b-form-input
                                v-model="provider.telephone"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Fax </label>
                            <b-form-input
                                v-model="provider.fax"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Celular </label>
                            <b-form-input
                                v-model="provider.mobile_number"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> E-mail </label>
                            <b-form-input
                                v-model="provider.email"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Website </label>
                            <b-form-input
                                v-model="provider.website"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>
                <b-row>
                    <b-col>
                        <p class="col-header">
                            Información de facturación
                        </p>

                        <b-form-group>
                            <label> Nombre </label>
                            <b-form-input
                                v-model="provider.billing_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Nit </label>
                            <b-form-input
                                v-model="provider.billing_identifier"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <label> Dirección de facturación </label>
                            <b-form-input
                                v-model="provider.billing_address"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Código postal de facturación">
                            <b-form-input
                                v-model="provider.billing_postcode"
                                type="email"
                                placeholder=""
                            >
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