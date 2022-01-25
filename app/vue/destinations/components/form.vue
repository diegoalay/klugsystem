<script>
export default {
    props: {
        destination: {
            required: true,
            type: Object
        },
        view_type: {
            default: 'new'
        },
        main_path: {
            required: true
        }
    },
    components: {

    },
    data() {
        return {
            options: {
                truck_types: []   
            },
            alert: {
                title: 'Destinos:'
            }
        }
    },
    mounted() {
        this.getTruckTypes()
    },
    methods: {
        onSubmit(){
            if (this.view_type === 'new') {
                this.postForm()
            } else {
                this.putForm()
            }
        },
        postForm(){
            let url = `${this.main_path}.json`
            let form = {
                destination: this.destination
            }
            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$router.push(`/${result.data.id}`)
                    this.notification('creado exitosamente.')
                } else {
                    this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            let url = `${this.main_path}/${this.destination.id}.json`
            let form = {
                destination: this.destination
            }
            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.notification('actualizado exitosamente.')
                } else {
                    this.notification(result.data.message.errors)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getTruckTypes(){
            this.http.get(`${this.main_path}/truck_types.json`).then(result => {
                if (result.successful) {
                    this.options.truck_types = result.data
                }
            }).catch(error => {
                console.log(error)
            }) 
        },
        notification(text, type = "success"){
            this.$notify({
                groups: "foo",
                title: this.alert.title,
                type,
                text
            })
        },
    }
}
</script>

<template>
    <b-card>    
        <b-card-body>
            <b-form @submit.prevent="onSubmit">
                <b-form-group label="Nombre">
                    <b-form-input
                        v-model="destination.name"
                        type="text"
                        placeholder=""
                        required
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Precio">
                    <b-form-input
                        v-model="destination.price"
                        type="number"
                        placeholder=""
                        required
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Galones">
                    <b-form-input
                        v-model="destination.gallons"
                        type="number"
                        placeholder=""
                        required
                        >
                    </b-form-input>
                </b-form-group>

                <b-form-group label="Costo km">
                    <b-form-input
                        v-model="destination.cost_km"
                        type="number"
                        placeholder="">
                    </b-form-input>
                </b-form-group>
        
                <b-form-group label="Total km">
                    <b-form-input
                        v-model="destination.total_km"
                        type="number"
                        placeholder="">
                    </b-form-input>
                </b-form-group>
                <b-form-group label="Tipo de Camión">
                    <b-form-select 
                        v-model="destination.truck_type" 
                        :options="options.truck_types"
                        required
                        >
                    </b-form-select>
                </b-form-group>
                
                <b-button type="submit" variant="primary">Guardar</b-button>
                <b-button type="reset" variant="default">Limpiar</b-button>
            </b-form>
            <notifications group="foo" />
        </b-card-body>
    </b-card>
</template>