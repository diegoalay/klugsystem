<script>
export default {
    props: {
        client_type: {
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
            if (this.client_type.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.config('client_types')
            let form = {
                client_type: this.client_type
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$toast.success('Tipo de cliente creado exitosamente.')
                    this.$router.push(this.url.config('client_types/:id', { id: result.data.id }).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.config('client_types/:id', {id: this.client_type.id})
            let form = {
                client_type: this.client_type
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Tipo de cliente actualizado exitosamente.')
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
                        v-model="client_type.name"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>


                <b-form-group label="Nota">
                    <b-form-textarea
                        v-model="client_type.note"
                        placeholder="Ingrese observaciones"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>