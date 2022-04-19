<script>

export default {
    props: {
        user: {
            required: true,
            type: Object
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
            if (this.user.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.admin('users')
            let form = {
                user: this.user
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Usuario creado exitosamente.')
                    this.$router.push(this.url.admin('users/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.admin('users/:id', {id: this.user.id})

            let form = {
                user: this.user
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Usuario actualizado exitosamente.')
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
                    <label> Nombre </label>

                    <b-form-input
                        v-model="user.first_name"
                        type="text"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <label> Apellido </label>
                    <b-form-input
                        v-model="user.first_surname"
                        type="text"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="E-Mail">
                    <b-form-input
                        v-model="user.email"
                        type="email"
                        placeholder="">
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Nota">
                    <b-form-textarea
                        v-model="user.note"
                        placeholder="Ingrese observaciones"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>