<script>

export default {
    props: {
        role: {
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
            if (this.role.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.admin('roles')
            let form = {
                role: this.role
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Rol creado exitosamente.')
                    this.$router.push(this.url.admin('roles/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.admin('roles/:id', {id: this.role.id})

            let form = {
                role: this.role
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Rol actualizado exitosamente.')
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
                        v-model="role.name"
                        type="text"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>