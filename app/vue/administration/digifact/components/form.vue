<script>
import componentInputPassword from 'vueApp/components/form/password.vue'

export default {
    props: {
        digifact: {
            required: true,
            type: Object
        }
    },
    components: {
        'input-password': componentInputPassword
    },
    methods: {
        putForm(showMessage = true){
            const url = this.url.admin('digifact')
            let form = {
                digifact: this.digifact
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    if (showMessage) {
                        this.$toast.success('Configuración de digifact actualizada exitosamente.')
                    }
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        validateCredentials(){
            this.putForm(false)

            setTimeout(() => {
                const url = this.url.admin('digifact/validate')

                this.http.post(url).then(result => {
                    if (result.successful) {
                        for(let key in result.data) {
                            this.$set(this.digifact, key, result.data[key])
                        }

                        this.$toast.success('La configuración de digifact ha sido verificada exitosamente.')
                    } else {
                        this.$set(this.digifact, 'digifact_status', false)
                        this.$set(this.digifact, 'digifact_errors', result.error.message)

                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }, 500)
        },
        statusMessage(){
            if (this.digifact.digifact_status) {
                return 'Verificado exitosamente.'
            } else {
                return this.digifact.digifact_errors
            }
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
                        NIT <sup class="text-danger">*</sup>
                    </template>

                    <b-form-input
                        name="digifact_billing_identifier"
                        v-model="digifact.digifact_billing_identifier"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Usuario <sup class="text-danger">*</sup>
                    </template>

                    <b-form-input
                        name="digifact_user"
                        v-model="digifact.digifact_user"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <input-password
                    :required="true"
                    input-text="Contraseña"
                    :input-init-value="digifact.digifact_password"
                    @input="digifact.digifact_password = $event"
                />

                <b-form-group>
                    <template #label>
                        Estado
                    </template>

                    <b-input-group>
                        <template #prepend>
                            <b-input-group-text>
                                <div v-if="digifact.digifact_status" class="text-success">
                                    <font-awesome-icon icon="check" />
                                </div>
                                <div v-else class="text-danger">
                                    <font-awesome-icon icon="xmark" />
                                </div>
                            </b-input-group-text>
                        </template>

                        <b-form-input
                            :value="statusMessage()"
                            type="text"
                            readonly
                        >
                        </b-form-input>
                    </b-input-group>
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button @click="validateCredentials" variant="success">Validar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>