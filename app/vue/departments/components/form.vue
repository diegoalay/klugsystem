<script>
export default {
    props: {
        department: {
            required: true,
            type: Object
        }
    },
    components: {

    },
    data() {
        return {
            options: {
                departments: []
            }
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.department.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('departments')
            let form = {
                department: this.department
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Departament creado exitosamente.')
                    this.$router.push(`/departments/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('departments/:id', {id: this.department.id})
            let form = {
                department: this.department
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Departament actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            const url = this.url.build('departments/options')
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
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
                    <b-col cols="12">
                        <b-form-group>
                            <label> Nombre del departmento <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="department.name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>

                        <b-form-group label="Departamento mayor">
                            <b-form-select v-model="department.departments_id" :options="options.departments"></b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>