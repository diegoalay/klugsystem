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
            this.postForm()
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
                        <label> Valor inicial <sup class="text-danger">*</sup> </label>

                        <b-form-input
                            v-model="cash_register.initial_value"
                            type="number"
                            placeholder=""
                            required
                        >
                        </b-form-input>
                    </b-form-group>
                </b-container>

                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>