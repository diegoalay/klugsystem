<script>
export default {
    props: {
        event_type: {
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
            if (this.event_type.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.config('event_types')
            let form = {
                event_type: this.event_type
            }

            this.http.post(url, form).then(result => {
                console.log(result)
                if (result.successful) {
                    this.$toast.success('Tipo de evento creado exitosamente.')
                    this.$router.push(this.url.config('event_types/:id', {id: result.data.id}).toString(false))
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.config('event_types/:id', {id: this.event_type.id})
            let form = {
                event_type: this.event_type
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
                <b-form-group>
                    <label> Nombre <sup class="text-danger">*</sup> </label>

                    <b-form-input
                        v-model="event_type.name"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Nota">
                    <b-form-textarea
                        v-model="event_type.note"
                        placeholder="Ingrese observaciones"
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