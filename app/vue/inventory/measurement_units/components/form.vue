<script>
export default {
    props: {
        measurement_unit: {
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
            if (this.measurement_unit.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.inventory('measurement_units')
            let form = {
                measurement_unit: this.measurement_unit
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Unidad de medida creada exitosamente.')
                    this.$router.push(this.url.inventory('measurement_units/:id', { id: result.data.id }).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.inventory('measurement_units/:id', {id: this.measurement_unit.id})
            let form = {
                measurement_unit: this.measurement_unit
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Unidad de medida actualizada exitosamente.')
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
                            <label> Nombre <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="measurement_unit.name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
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