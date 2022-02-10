<script>
export default {
    props: {
        payment_method: {
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
            if (this.payment_method.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('payment_methods')
            const form = {
                payment_method: this.payment_method
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Método de pago creado exitosamente.')

                    this.$router.push(`/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('payment_methods/:id', {id: this.payment_method.id})
            const form = {
                payment_method: this.payment_method
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Método de pago actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        validatePercentage(key){
            const value = this.payment_method[key]

            if (value > 100 || value < 0) {
                this.$toast.warn('El porcentaje debe ser mayor a 0 y menor a 100.')

                this.payment_method[key] = 0
            }
        }
    }
}
</script>

<template>
    <b-form @submit.prevent="onSubmit">
        <b-card>
            <b-card-body>
                <b-container>
                    <b-form-group>
                        <label> Método de pago <sup class="text-danger">*</sup> </label>

                        <b-form-input
                            v-model="payment_method.name"
                            type="text"
                            placeholder=""
                            required
                        >
                        </b-form-input>
                    </b-form-group>

                    <b-row>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Interés (%) </label>

                                <b-form-input
                                    :change="validatePercentage('interest_percentage')"
                                    v-model="payment_method.interest_percentage"
                                    type="number"
                                    placeholder=""
                                    min=0
                                    max=100
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>

                        <b-col sm="12">
                            <b-form-group>
                                <label> Interés (Q.) </label>

                                <b-form-input
                                    v-model="payment_method.interest_value"
                                    type="number"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>

                    <b-row>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Descuento (%) </label>

                                <b-form-input
                                    :change="validatePercentage('discount_percentage')"
                                    v-model="payment_method.discount_percentage"
                                    type="number"
                                    placeholder=""
                                    min=0
                                    max=100
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>

                        <b-col sm="12">
                            <b-form-group>
                                <label> Descuento (Q.) </label>

                                <b-form-input
                                    v-model="payment_method.discount_value"
                                    type="number"
                                    placeholder=""
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>

                    <b-form-group>
                        <label> Estado </label>

                            <b-form-checkbox v-model="payment_method.status">
                            {{ payment_method.status ? 'Deshabilitar pago' : 'Habilitar pago' }}
                            </b-form-checkbox>
                    </b-form-group>
                </b-container>

                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button type="reset" variant="outline-dark">Limpiar</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>