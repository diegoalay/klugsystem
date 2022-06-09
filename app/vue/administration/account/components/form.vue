<script>
export default {
    props: {
        account: {
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
        putForm(){
            const url = this.url.admin('account')
            let form = {
                account: this.account
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Configuración de cuenta actualizada exitosamente.')

                    this.$set(this.store.global, 'account', result.data)
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
    <b-form @submit.prevent="putForm">
        <b-card>
            <b-card-body>
                <b-form-group>
                    <template #label>
                        Nombre Comercial <sup class="text-danger">*</sup>
                    </template>

                    <b-form-input
                        v-model="account.name"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-row>
                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                Teléfono <sup class="text-danger">*</sup>
                            </template>

                            <b-form-input
                                v-model="account.telephone"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                E-mail
                            </template>

                            <b-form-input
                                v-model="account.email"
                                type="email"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col md="4" sm="12">
                        <b-form-group>
                            <template #label>
                                Sitio web
                            </template>

                            <b-form-input
                                v-model="account.website"
                                type="text"
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