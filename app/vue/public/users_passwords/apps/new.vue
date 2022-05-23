<script type="text/javascript">
import componenentAutocomplete from 'vueApp/components/form/password.vue'

export default {
    data() {
        return {
            user: {
                reset_password_token: null,
                password_confirmation: null,
                password: null
            },
            resetPassword: false,
            loading: false
        }
    },
    components: {
        'input-password': componenentAutocomplete
    },
    mounted() {
        this.$set(this.user, 'reset_password_token', this.$route.query.reset_password_token)
    },
    methods: {
        submitForm(event) {
            if(event){
                event.preventDefault()
            }

            console.log(this.user)

            const form = {
                user: this.user
            }

            if  (!this.validatePassword()) {
                this.$toast.error('Las contraseñas no coinciden.')

                return
            }

            if  (!this.validatePasswordLength()) {
                this.$toast.error('La contraseña debe contener al menos 6 caracteres')

                return
            }

            this.loading = true
            const url = this.url.build('password')
            this.http.put(url, form).then(result => {
                this.loading = false
                if (result.successful) {
                    this.$toast.success('La contraseña ha sido restablecida exitosamente')


                    setTimeout(() => {
                        this.url.go(`/dashboard`)
                    }, 200)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                this.loading = false
                console.log(error)
            })
        },

        validatePassword(){
            if (this.user.password_confirmation !== this.user.password) {
                return false
            }

            return true
        },

        validatePasswordLength(){
            if (this.user.password.length < 6) {
                return false
            }

            return true
        },

        goToLogin(){
            this.$router.push('/login')
        }
    }
}
</script>

<template>
    <div class="container">
        <div class="card card-container">
            <b-form autocomplete="off" @submit.prevent="submitForm">
                <img id="profile-img" class="profile-img-card" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png" />
                <p id="profile-name" class="profile-name-card"></p>

                <div class="form-signin">
                    <input-password inputText="Repite la contraseña" @input="user.password = $event" />

                    <input-password inputText="Repite la contraseña" @input="user.password_confirmation = $event" />

                    <br>
                    <div>
                       <div class="text-left">
                            <b-button :disabled="loading" type="submit" variant="primary">Recuperar contraseña</b-button>
                        </div>

                        <div class="text-right">
                            <a @click="goToLogin()" variant="outline-dark" class="forgot-passwoord">Iniciar sesión</a>
                        </div>
                    </div>
                </div>
            </b-form>
        </div>
    </div>
</template>