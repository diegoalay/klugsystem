<script>
export default {
    props: {
        billing_field: {
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
            if (this.billing_field.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            let color = this.billing_field.color

            if (color['hex']) {
                color['hex']
            } else {
                color = this.billing_field.color
            }

            const url = this.url.admin('billing_fields')
            const form = {
                billing_field: {
                    ...this.billing_field,
                    color
                }
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Campo de facturación creado exitosamente.')
                    this.$router.push(this.url.admin('billing_fields/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.admin('billing_fields/:id', {id: this.billing_field.id})
            const form = {
                billing_field: {
                    ...this.billing_field,
                    color: this.billing_field.color['hex']
                }
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Campo de facturación actualizado exitosamente.')
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
                <b-form-group>
                    <template #label>
                        Titulo <sup class="text-danger">*</sup>
                    </template>

                    <b-form-input
                        v-model="billing_field.title"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group v-if="billing_field.color">
                    <template #label>
                        Color de letra <sup class="text-danger">*</sup>
                    </template>

                    <color-picker
                        v-model="billing_field.color"
                        :preset-colors="[
                            '#f00', '#00ff00', '#00ff0055', 'rgb(201, 76, 76)', 'rgba(0,0,255,1)', 'hsl(89, 43%, 51%)', 'hsla(89, 43%, 51%, 0.6)'
                        ]"
                    >
                    </color-picker>
                </b-form-group>

                <b-form-group label>
                    <template #label>
                        Posición x (cm) <sup class="text-danger">*</sup>
                    </template>

                    <b-form-input
                        v-model="billing_field.position_x"
                        type="number"
                        step="any"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Posición y (cm) <sup class="text-danger">*</sup>
                    </template>
                    <b-form-input
                        v-model="billing_field.position_y"
                        type="number"
                        step="any"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <template #label>
                        Valor default
                    </template>

                    <b-form-input
                        v-model="billing_field.value"
                        type="text"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>