<script type="text/javascript">
import componenentAutocomplete from 'vueApp/components/form/password.vue'

export default {
    data() {
        return {
            user: {
                email: null,
                password: null
            },
            resetPassword: false,
            loading: false
        }
    },
    components: {
        'input-password': componenentAutocomplete
    },
    methods: {
        submitForm(event) {
            if(event){
                event.preventDefault()
            }

            if (this.resetPassword) {
                this.postPassword()
            } else {
                this.postLogin()
            }
        },

        postPassword(event){
            const form = {
                user: {
                    email: this.user.email
                }
            }

            this.loading = true
            const url = this.url.build('password')
            this.http.post(url, form).then(result => {
                this.loading = false
                if (result.successful) {
                    this.$toast.success('Hemos enviado un correo electrónico para que puedas restablecer la contraseña.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postLogin(){
            const form = {
                user: {
                    email: this.user.email,
                    password: this.user.password
                }
            }

            this.loading = true
            const url = this.url.build('login')
            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.loading = false
                    this.$toast.success('Bienvenido.')

                    setTimeout(() => {
                        this.url.go(`/dashboard`)
                    }, 200)
                } else {
                    this.loading = false
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
    }
}
</script>

<template>
    <div class="container">
        <div class="card card-container">
            <b-form @submit.prevent="submitForm">
                <img id="profile-img" class="profile-img-card" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png" />
                <p id="profile-name" class="profile-name-card"></p>

                <div class="form-signin">
                    <b-form-group>
                        <label> E-Mail <sup class="text-danger">*</sup> </label>

                        <b-form-input
                            v-model="user.email"
                            type="text"
                            placeholder="Ingrese su correo electrónico"
                            required
                        >
                        </b-form-input>
                    </b-form-group>

                    <input-password v-if="!resetPassword" inputText="Repite la contraseña" @input="user.password = $event" />

                    <div class='buttons' v-if="!resetPassword">
                        <div class="text-left">
                            <b-button :disabled="loading" type="submit" variant="primary">Iniciar sesión</b-button>
                        </div>

                        <div class="text-right">
                            <a @click="resetPassword = true" variant="outline-dark" class="forgot-passwoord">
                                ¿Olvidaste tu contraseña?
                            </a>
                        </div>
                    </div>
                    <div v-else >
                       <div class="text-left">
                            <b-button :disabled="loading" type="submit" variant="primary">Recuperar contraseña</b-button>
                        </div>

                        <div class="text-right">
                            <a @click="resetPassword = false" variant="outline-dark" class="forgot-passwoord">Iniciar sesión</a>
                        </div>
                    </div>
                </div>
            </b-form>
        </div>
    </div>
</template>