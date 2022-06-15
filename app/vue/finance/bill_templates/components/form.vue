<script>
export default {
    props: {
        bill_template: {
            required: true,
            type: Object
        }
    },
    components: {},
    data() {
        return {
            options: {}
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.bill_template.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        getOptions(){
            const url = this.url.finance('bill_templates/options')

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        postForm(){
            const url = this.url.finance('bill_templates')
            let form = {
                bill_template: this.bill_template
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Plantilla de facturación creada exitosamente.')
                    this.$router.push(this.url.finance('bill_templates/:id', { id: result.data.id }).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.finance('bill_templates/:id', {id: this.bill_template.id})
            let form = {
                bill_template: this.bill_template
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Plantilla de facturación actualizada exitosamente.')
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
                    <b-col md="6" sm="12">
                        <b-form-group>
                            <label> Título <sup class="text-danger">*</sup> </label>

                            <b-form-input
                                v-model="bill_template.title"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                        </b-form-group>
                    </b-col>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label> Unidad <sup class="text-danger">*</sup></template>
                            <b-form-select
                                required
                                v-model="bill_template.measurement_unit"
                                :options="options.measurement_units"
                            >
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                    <b-col md="3" sm="12">
                        <b-form-group>
                            <template #label> Bien / Servicio <sup class="text-danger">*</sup></template>
                            <b-form-select
                                required
                                v-model="bill_template.product_type"
                                :options="options.product_types"
                            >
                            </b-form-select>
                        </b-form-group>
                    </b-col>
                </b-row>

                <b-form-group>
                    <template #label> Descripción <sup class="text-danger">*</sup> </template>
                    <b-form-textarea
                        required
                        v-model="bill_template.name"
                        placeholder="Ingrese descripción"
                        autocomplete="off"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <div class="text-right">
                    <b-button type="submit" variant="primary">Guardar</b-button>
                </div>
            </b-card-body>
        </b-card>
    </b-form>
</template>