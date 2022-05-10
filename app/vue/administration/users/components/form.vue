<script>

export default {
    props: {
        user: {
            required: true,
            type: Object
        }
    },
    data() {
        return {
            options: []
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.user.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        getOptions(){
            const url = this.url.admin('users/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
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
                    <template #label> Nombre <sup class="text-danger">*</sup></template>
                    <b-form-input
                        v-model="user.first_name"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label> Apellido <sup class="text-danger">*</sup></template>
                    <b-form-input
                        v-model="user.first_surname"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label> E-mail <sup class="text-danger">*</sup>  </template>
                    <b-form-input
                        v-model="user.email"
                        type="email"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Rol <sup class="text-danger"> *</sup>
                    </template>
                    <b-form-select
                        v-model="user.role_id"
                        :options="options.roles"
                        size="sm"
                        class="mt-3"
                        required
                    >
                    </b-form-select>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Sucursal <sup class="text-danger"> *</sup>
                    </template>
                    <b-form-select
                        v-model="user.branch_office_id"
                        :options="options.branch_offices"
                        size="sm"
                        class="mt-3"
                        required
                    >
                    </b-form-select>
                </b-form-group>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>