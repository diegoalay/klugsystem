<script>

export default {
    props: {
        contact: {
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
            if (this.contact.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('contacts')
            let form = {
                contact: this.contact
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Contacto creado exitosamente.')
                    this.$router.push(this.url.crm('contacts/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('contacts/:id', {id: this.contact.id})

            let form = {
                contact: this.contact
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Contacto actualizado exitosamente.')
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
                <b-row>
                    <b-col md="12" sm="12">
                        <b-form-group>
                            <template #label>
                                <label> Nombre <sup class="text-danger">*</sup> </label>
                            </template>

                            <b-form-input
                                v-model="contact.first_name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group>
                            <template #label>
                                <label> Apellido <sup class="text-danger">*</sup> </label>
                            </template>

                            <b-form-input
                                v-model="contact.first_surname"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Teléfono">
                            <b-form-input
                                v-model="contact.telephone"
                                type="text"
                                placeholder=""
                                >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Celular">
                            <b-form-input
                                v-model="contact.mobile_number"
                                type="text"
                                placeholder="">
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="E-Mail">
                            <b-form-input
                                v-model="contact.email"
                                type="email"
                                placeholder="">
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Fax">
                            <b-form-input
                                v-model="contact.fax"
                                type="text"
                                placeholder="">
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Fecha de nacimiento">
                            <component-datepicker
                                :focus="false"
                                lang="es"
                                valueType="format"
                                format="DD-MM-YYYY"
                                v-model="contact.birthdate"
                                placeholder="">
                            </component-datepicker>
                        </b-form-group>

                        <b-form-group label="Nota">
                            <b-form-textarea
                                v-model="contact.note"
                                placeholder="Ingrese observaciones"
                                rows="3"
                            >
                            </b-form-textarea>
                        </b-form-group>
                    </b-col>
                </b-row>
                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>