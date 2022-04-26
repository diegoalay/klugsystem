<script type="text/javascript">
    export default {
        data() {
            return {
                user: {
                    email: null,
                    password: null
                }
            }
        },
        mounted(){},
        methods: {
            postLogin(event){
                if(event){
                    event.preventDefault()
                }

                const form = {
                    user: {
                        email: this.user.email,
                        password: this.user.password
                    }
                }

                const url = this.url.build('login')
                this.http.post(url, form).then(result => {
                    if (result.successful) {
                        this.$toast.success('Bienvenido.')

                        setTimeout(() => {
                            this.url.go(`/dashboard`)
                        }, 1000)
                    } else {
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
            <b-form @submit.prevent="postLogin">
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

                    <b-form-group>
                        <label> Contraseña <sup class="text-danger">*</sup> </label>

                        <b-form-input
                            v-model="user.password"
                            type="password"
                            placeholder="Ingrese su contraseña"
                            required
                        >
                        </b-form-input>
                    </b-form-group>

                    <div class="text-right">
                        <b-button type="submit" variant="primary">Iniciar sesión</b-button>
                    </div>
                </div>
            </b-form>
        </div>
    </div>
</template>