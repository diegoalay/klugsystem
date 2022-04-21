<script>
export default {
    props: {
        product_transaction_type: {
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
            if (this.product_transaction_type.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.config('product_transaction_types')
            let form = {
                product_transaction_type: this.product_transaction_type
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$toast.success('Tipo de transacción de producto creada exitosamente.')
                    this.$router.push(this.url.config('product_transaction_types/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.config('product_transaction_types/:id', {id: this.product_transaction_type.id})
            let form = {
                product_transaction_type: this.product_transaction_type
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Tipo de transacción de producto actualizada exitosamente.')
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
                <b-form-group>
                    <label> Nombre <sup class="text-danger">*</sup> </label>

                    <b-form-input
                        v-model="product_transaction_type.name"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <label> Nota </label>

                    <b-form-textarea
                        v-model="product_transaction_type.note"
                        placeholder="Ingrese observaciones"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <div class="text-right">
                    <b-button v-if="productTransactionCanBeEdited(product_transaction_type)" type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>