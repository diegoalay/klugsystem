<script>
export default {
    props: {
        expediture: {
            required: true,
            type: Object
        }
    },
    components: {},
    data(){
        return {
            options: []
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.expediture.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.pos('expeditures')
            let form = {
                expediture: {
                    ...this.expediture,
                    cash_register: true
                }
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Gasto creado exitosamente.')
                    this.$router.push(this.url.pos('expeditures/:id', {id: result.data.id}))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.pos('expeditures/:id', {id: this.expediture.id})
            let form = {
                expediture: this.expediture
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Gasto actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            const url = this.url.pos('expeditures/options')

            this.http.get(url).then(response => {
                this.options = response.data
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
                    <label> Descripción <sup class="text-danger">*</sup> </label>

                    <b-form-input
                        v-model="expediture.description"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <label> Monto <sup class="text-danger">*</sup> </label>
                    <b-form-input
                        v-model="expediture.amount"
                        type="number"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group>
                    <label> Fecha de emisión </label>
                    <br>
                    <component-datepicker
                        v-model="expediture.expediture_date"
                        lang="es"
                        format="DD-MM-YYYY hh:mm"
                        type="datetime"
                        placeholder=""
                    >
                    </component-datepicker>
                </b-form-group>

                <b-form-group label="Tipo de gasto">
                    <b-form-select
                        v-model="expediture.expediture_type_id"
                        :options="options.expediture_types"
                    >
                        <template #first>
                            <option :value="null"> Seleccione un tipo de gasto </option>
                        </template>
                    </b-form-select>
                </b-form-group>

                <b-form-group label="Nota">
                    <b-form-textarea
                        v-model="expediture.note"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>

                <b-button type="submit" variant="primary">Guardar</b-button>
            </b-card-body>
        </b-card>
    </b-form>
</template>