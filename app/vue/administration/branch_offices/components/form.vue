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
            const url = this.url.admin('branch_offices')
            let form = {
                branch_office: this.branch_office
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Sucursal creada exitosamente.')
                    this.$router.push(this.url.admin('branch_offices/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.admin('branch_offices/:id', {id: this.branch_office.id})
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
                <b-row>
                    <b-col>
                        <p class="col-header">
                            Información general
                        </p>

                        <b-form-group>
                            <template #label>
                                Nombre <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                Teléfono <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.telephone"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Código Postal">
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

                        <b-form-group label="Facturación electrónica" v-if="store.global.account.electronic_billing">
                            <b-form-checkbox
                                v-model="branch_office.electronic_billing"
                            >
                                {{ branch_office.electronic_billing ? 'Deshabilitar' : 'Habilitar'}}
                            </b-form-checkbox>
                        </b-form-group>
                    </b-col>
                </b-row>
                <b-row v-if="branch_office.electronic_billing">
                    <b-col>
                        <p class="col-header">
                            Información de facturación Electrónica
                        </p>

                        <b-form-group>
                            <template #label>
                                Dirección <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.billing_address"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                Código Postal <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.billing_postcode"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                Municipio <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.billing_municipality"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                Departamento <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.billing_department"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                Código de establecimiento <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="branch_office.billing_identifier"
                                type="text"
                                placeholder=""
                                required
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