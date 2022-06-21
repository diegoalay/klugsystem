<script>
    import componenentAutocomplete from 'vueApp/components/component-autocomplete.vue'

    export default {
        props: {
            event: {
                type: Object,
                required: true
            }
        },

        components: {
            'component-autocomplete': componenentAutocomplete
        },

        data(){
            return {
                time_start: null,
                time_end: null
            }
        },

        mounted(){
            if (this.isEdition()) {
                this.event.date = this.date.parseISOString(this.event.date)
                this.time_start = this.date.parseISOString(this.event.time_start)
                this.time_end = this.date.parseISOString(this.event.time_end)
            }
        },

        methods: {
            onSubmit(){
                if (this.isEdition()) {
                    this.putEvent()
                } else {
                    this.postEvent()
                }
            },

            postEvent(){
                const url = this.url.dashboard('events')
                const form = {
                    event: this.event
                }

                this.http.post(url, form).then(result => {
                    if (result.successful) {
                        this.$toast.success('Evento creado exitosamente.')

                        this.$emit('submit', 'post', result.data)
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },

            putEvent(){
                const url = this.url.dashboard('events/:id', {id: this.event.id})
                const form = {
                    event: this.event
                }

                this.http.put(url, form).then(result => {
                    if (result.successful) {
                        this.$toast.success('Evento actualizado exitosamente.')

                        this.$emit('submit', 'put', result.data)
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },

            destroyEvent() {
                const url = this.url.dashboard('events/:id', {id: this.event.id})

                this.http.delete(url).then(result => {
                    if (result.successful) {
                        this.$toast.success('Evento eliminado exitosamente.')

                        this.$emit('submit', 'destroy', result.data)
                    } else {
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            },

            isCreation(){
                return !this.event.id ? true : false
            },

            isEdition(){
                return this.event.id ? true : false
            }
        },

        watch: {
            time_start(date){
                let start = new Date(this.event.date.setHours(date.getHours(), date.getMinutes(), 0))
                this.$set(this.event, 'time_start', start)
            },
            time_end(date){
                let end = new Date(this.event.date.setHours(date.getHours(), date.getMinutes(), 0))
                this.$set(this.event, 'time_end', end)
            }
        }
    }
</script>

<template>
    <b-form @submit.prevent="onSubmit">
        <b-row>
            <b-col md="12" sm="12">
                <b-form-group>
                    <template #label>
                        <label> Título <sup class="text-danger">*</sup> </label>
                    </template>

                    <b-form-input
                        v-model="event.title"
                        type="text"
                        placeholder=""
                        required
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Lugar">
                    <b-form-input
                        v-model="event.location"
                        type="text"
                        placeholder=""
                    >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Horario">
                    <b-row>
                        <b-col md="6" sm="4">
                            <component-datepicker
                                v-model="time_start"
                                lang="es"
                                type="time"
                                format="hh:mm A"
                                placeholder="Inicia"
                            >
                            </component-datepicker>
                        </b-col>
                        <b-col md="6" sm="4">
                            <component-datepicker
                                v-model="time_end"
                                type="time"
                                format="hh:mm A"
                                placeholder="Termina"
                            >
                            </component-datepicker>
                        </b-col>
                    </b-row>
                </b-form-group>

                <b-form-group label="Nota">
                    <b-form-textarea
                        v-model="event.description"
                        placeholder="Ingrese descripción"
                        rows="3"
                    >
                    </b-form-textarea>
                </b-form-group>
            </b-col>
        </b-row>

        <div class="text-right">
            <b-button v-if="isEdition()" @click.prevent="destroyEvent" variant="danger">Eliminar</b-button>
            <b-button type="submit" variant="primary">Guardar</b-button>
        </div>
    </b-form>
</template>
