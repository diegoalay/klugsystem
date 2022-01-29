<script>
export default {
    props: {
        department: {
            required: true,
            type: Object
        },
        main_path: {
            required: true
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
            const url = `${this.main_path}.json`
            let form = {
                department: this.department
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$router.push(`/${result.data.id}`)

                } else {

                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = `${this.main_path}/${this.department.id}.json`
            let form = {
                department: this.department
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {

                } else {

                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            const url = `${this.main_path}/${this.department.id}.json`
            this.http.get(`${this.main_path}/options.json`).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {

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
                <b-container>
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
                </b-container>

                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button type="reset" variant="outline-dark">Limpiar</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>