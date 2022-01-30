<script>
export default {
    props: {
        brand: {
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

        }
    },
    mounted() {

    },
    methods: {
        onSubmit(){
            if (this.brand.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            let url = `${this.main_path}.json`
            let form = {
                brand: this.brand
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$router.push(`/${result.data.id}`)
                    // this.notification('creado exitosamente.')
                } else {
                    // this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            let url = `${this.main_path}/${this.brand.id}.json`
            let form = {
                brand: this.brand
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    // this.notification('actualizado exitosamente.')
                } else {
                    // this.notification(result.data.message.errors)
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
                        <b-col cols="8">
                            <b-form-group>
                                <label> Nombre de la marca <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="brand.name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
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