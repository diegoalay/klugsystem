<script>
import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'

export default {
    components:{
        'component-autocomplete': componenentAutocomplete
    },
    props: {
        employee: {
            required: true,
            type: Object
        }
    },
    data() {
        return {

        }
    },
    mounted() {
    },
    methods: {
        onSubmit(){
            if (this.employee.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.hr('employees')
            let form = {
                employee: this.employee
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Empleado creado exitosamente.')
                    this.$router.push(`/employees/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.hr('employees/:id', {id: this.employee.id})
            let form = {
                employee: this.employee
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Empleado actualizado exitosamente.')
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
                <p class="col-header">
                    Información general
                </p>

                <b-row>
                    <b-col sm="12">
                        <b-form-group>
                            <label> Primer nombre <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="employee.first_name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col sm="12">
                        <b-form-group>
                            <label> Segundo nombre </label>

                            <b-form-input
                                v-model="employee.second_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col sm="12">
                        <b-form-group>
                            <label> Tercer nombre </label>

                            <b-form-input
                                v-model="employee.third_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col sm="12">
                        <b-form-group>
                            <label> Primer apellido <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="employee.first_surname"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col sm="12">
                        <b-form-group>
                            <label> Segundo apellido </label>

                            <b-form-input
                                v-model="employee.second_surname"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col sm="12">
                        <b-form-group>
                            <label> Nombre por matrimonio </label>

                            <b-form-input
                                v-model="employee.married_name"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-row>
                    <b-col sm="12">
                        <b-form-group>
                            <label> DPI </label>

                            <b-form-input
                                v-model="employee.identity_document_number"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>

                    <b-col sm="12">
                        <b-form-group>
                            <label> Número de pasaporte </label>

                            <b-form-input
                                v-model="employee.passport_number"
                                type="text"
                                placeholder=""
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                </b-row>

                <br>
                <p class="col-header">
                    Acceso al sistema
                </p>

                <b-row>
                    <b-col sm="12">
                        <b-form-group>
                            <label> Asignar usuario </label>

                                <component-autocomplete
                                    :placeholder="`Buscar por correo electrónico`"
                                    :default-option-id="employee.user_id"
                                    text-field="email"
                                    :endpoint="'/users/search'"
                                    @select="(option) => employee.user_id = option.id"
                                >
                                </component-autocomplete>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>