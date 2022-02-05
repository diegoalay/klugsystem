<script>
export default {
    props: {
        payment_method: {
            required: true,
            type: Object
        },
        main_path: {
            required: true
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
            if (this.payment_method.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            let url = `${this.main_path}.json`
            let form = {
                payment_method: this.payment_method
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$router.push(`/${result.data.id}`)
                    this.notification('creado exitosamente.')
                } else {
                    // this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            let url = `${this.main_path}/${this.payment_method.id}.json`
            let form = {
                payment_method: this.payment_method
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

        validatePercentage(key){
            const value = this.payment_method[key]

            if (value > 100 || value < 0) {
                alert('Porcentaje inválido')

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
                        <b-col>
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

                        <b-col>
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
                        <b-col>
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

                        <b-col>
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