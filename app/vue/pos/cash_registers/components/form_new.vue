<script>
export default {
    props: {},
    components: {},
    data() {
        return {
            cash_register: {
                id: null
            }
        }
    },
    mounted() {},
    methods: {
        onSubmit(){
            this.postForm()
        },
        postForm(){
            const url = this.url.pos('cash_register/create')
            let form = {
                cash_register: this.cash_register
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$set(this.store.global, 'cash_register', result.data)

                    this.$toast.success('Caja apreturada exitosamente.')
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
    <section>
        <component-header-form
            title="Apertura de caja"
            :show-buttons="false"
        >
        </component-header-form>
        <b-form @submit.prevent="onSubmit">
            <b-card>
                <b-card-body>
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

                    <b-button type="submit" variant="primary">Guardar</b-button>
                </b-card-body>
            </b-card>
        </b-form>
    </section>
</template>