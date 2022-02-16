<script>
export default {
    props: {
        cash_register: {
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
            if (this.cash_register.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('cash_registers')
            let form = {
                cash_register: this.cash_register
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Marca creada exitosamente.')
                    this.$router.push(`/cash_registers/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('cash_registers/:id', {id: this.cash_register.id})
            let form = {
                cash_register: this.cash_register
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Marca actualizada exitosamente.')
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
                        <b-col cols="8">
                            <b-form-group>
                                <label> Nombre de la marca <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="cash_register.name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>
                </b-container>

                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button type="reset" variant="outline-dark">Limpiar</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>