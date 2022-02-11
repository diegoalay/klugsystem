<script>
export default {
    props: {
        catalog_event_type: {
            required: true,
            type: Object
        }
    },
    components: {},
    data() {
        return {

        }
    },
    mounted() {},
    methods: {
        onSubmit(){
            if (this.catalog_event_type.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('catalog/event_types')
            let form = {
                catalog_event_type: this.catalog_event_type
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$toast.success('Tipo de evento creado exitosamente.')
                    this.$router.push(`/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('catalog/event_types/:id', {id: this.catalog_event_type.id})
            let form = {
                catalog_event_type: this.catalog_event_type
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Tipo de evento actualizado exitosamente.')
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
                <b-container>
                    <b-row>
                        <b-col cols="8">
                            <b-form-group>
                                <label> Nombre <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="catalog_event_type.name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>

                        <b-form-group label="Nota">
                            <b-form-textarea
                                v-model="catalog_event_type.note"
                                placeholder="Ingrese observaciones"
                                rows="3"
                            >
                            </b-form-textarea>
                        </b-form-group>
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