<script>
    export default {
        props: {
            event: {
                type: Object,
                required: true
            }
        },

        data(){
            return {

            }
        },
        methods: {
            onSubmit(){
                if (this.event.id) {
                    this.putEvent()
                } else {
                    this.postEvent()
                }
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
                        <label> título <sup class="text-danger">*</sup> </label>
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
                        <b-col>
                            <component-datepicker
                                v-model="event.time_start"
                                lang="es"
                                type="time"
                                format="hh:mm A"
                                placeholder="Inicia"
                            >
                            </component-datepicker>
                        </b-col>
                        <b-col>
                            <component-datepicker
                                v-model="event.time_end"
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
        <b-button type="submit" variant="primary">Guardar</b-button>
    </b-form>
</template>



