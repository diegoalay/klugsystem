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
            const url = this.url.inventory('departments')
            let form = {
                department: this.department
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Departament creado exitosamente.')
                    this.$router.push(this.url.inventory('departments/:id', { id: result.data.id }).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.inventory('departments/:id', {id: this.department.id})
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
            const url = this.url.inventory('departments/options')
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
                            <b-form-select v-model="department.department_id" :options="options.departments"></b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>