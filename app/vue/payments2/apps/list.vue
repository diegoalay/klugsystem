<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                options: {
                    truck_types: [],
                    destinations: [],
                    pilots: [],
                    units: []
                },
                truck_type: "tandem",
                pilot: null,
                destination: null,
                unit: null,
                diesel_price: 1,
                destinations: [],
                destination_selected: "",
                destination_fields: [{
                    label: 'Nombre',
                    key: 'name',
                    sortable: true
                },{
                    label: 'Gal.',
                    key: 'gallons',
                    sortable: false
                },{
                    label: 'Precio',
                    key: 'price',
                    sortable: true
                },{
                    label: 'Tot.',
                    key: 'total',
                    sortable: true
                },{
                    label: '',
                    key: 'actions'
                }],
                alert: {
                    title: 'Pago:'
                },
                payment: {
                    final: 0,
                    total: 0,
                    date_range: "",
                    expenses: 150,
                    additions: 0,
                    percentage: 10,
                    total_extras: 0,
                    total_expent: 0,
                    pilot_salary: 500,
                    pilot_payment: 0,
                    total_discount: 0,
                    expenses_details: null,
                    additions_details: null,
                    total_percentage: 0,
                    taxes_percentage: 1.19,
                    total_taxes_percentage: 0,
                }
            }
        },
        mounted() {
            this.getUnits()
            this.getPilots()
            this.getTruckTypes()
            this.getDestinations()
        },
        methods: {
            getPilots(){
                this.http.get(`/pilots.json`).then(response => {
                    this.options.pilots = response.data.map(e => {
                        return {
                            value: e.id,
                            text: e.first_name + " " + e.last_name
                        }
                    })
                }).catch(error => {
                    console.log(error)
                })
            },
            getUnits(){
                this.http.get(`/units.json`).then(response => {
                    this.options.units = response.data.map(e => {
                        return {
                            value: e.id,
                            text: e.alias
                        }
                    })
                }).catch(error => {
                    console.log(error)
                })
            },
            getDestinations(){
                this.http.get(`/destinations.json`).then(response => {
                    this.options.destinations = response.data
                }).catch(error => {
                    console.log(error)
                })
            },

            getTruckTypes(){
                this.http.get(`/destinations/truck_types.json`).then(response => {
                    this.options.truck_types = response.data
                }).catch(error => {
                    console.log(error)
                })
            },

            addDestination(){
                if (this.diesel_price > 0) {
                    let destination = this.options.destinations.find((e) => e.name.trim() === this.destination_selected)
                    if (destination) {
                        this.destinations.push({
                            index: this.destinations.length,
                            total: parseFloat(destination.price) + (this.diesel_price * parseFloat(destination.gallons)),
                            ...destination

                        })
                    } else {
                        this.notification("Ingrese un destino válido", "error")
                    }
                    // this.destination_selected = ""
                } else {
                    this.$refs.diesel_price.focus()
                    this.notification("Ingrese el precio del diesel", "error")
                }
            },
            
            deleteDestination(index){
                this.destinations.splice(index, 1)
            },

            notification(text, type = "success"){
                this.$notify({
                    groups: "foo",
                    title: this.alert.title,
                    type,
                    text
                })
            },
            validateNumber(value){
                if (!value > 0) {
                    value = 0
                }
                return value
            },
            print(){
                // if (!this.pilot) {
                //     this.notification("Seleccione piloto.", "error")
                // } else if (this.destinations.lengh === 0) {
                //     this.notification("No se han agregado destinos.", "warn")
                // } else {
                //     window.print()
                // }
                window.print()
            }
        },

        watch:{
            truck_type(value){
                
            },
            destinations(value) {
                var total = 0
                for (let i = 0; i < value.length; i++ ) {
                    total += value[i].total
                }
                this.payment.total = total
                this.payment.total_taxes_percentage = (total / this.payment.taxes_percentage).toFixed(2)
                this.payment.total_percentage = parseFloat(this.payment.total_taxes_percentage * parseFloat(this.payment.percentage / 100)).toFixed(2)
                this.payment.pilot_payment = parseFloat(parseFloat(this.payment.pilot_salary) + parseFloat(this.payment.total_percentage)).toFixed(2)
                this.payment.total_discount = parseFloat(this.payment.expenses - this.payment.total_expent).toFixed(2)
                this.payment.final = parseInt(this.payment.pilot_payment + this.payment.total_extras - this.payment.total_discount)
            },
            'payment.pilot_salary':{
                handler(value) {
                    value = this.validateNumber(value)
                    this.payment.pilot_payment = parseFloat(parseFloat(value) + parseFloat(this.payment.total_percentage)).toFixed(2)
                },
                immediate: true
            },
            'payment.expenses':{
                handler(value) {
                    value = this.validateNumber(value)
                    this.payment.total_discount = parseFloat(value)
                },
                immediate: true
            },
            'payment.total_expent'(value){
                value = this.validateNumber(value)
                this.payment.total_discount = parseFloat(parseFloat(this.payment.expenses) - parseFloat(this.payment.total_expent)).toFixed(2)
            },
            'payment.total_extras'(value){
                value = this.validateNumber(value)
                this.payment.final = parseInt(parseFloat(this.payment.pilot_payment) + parseFloat(value) - parseFloat(this.payment.total_discount))
            },
            'payment.total_discount'(value){
                value = this.validateNumber(value)
                this.payment.final = parseInt((this.payment.pilot_payment + this.payment.total_extras) - parseFloat(value)).toFixed(2)
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <b-card>
            <b-card-body>
                <div class="row">
                    <div class="col-md-5 col-sm-5 col-xs-5">
                        <b-form-group label="Porcentaje Interés">
                            <b-form-input v-model="payment.taxes_percentage" type="number"/>
                        </b-form-group>
                        <b-form-group label="Porcentaje Piloto">
                            <b-form-input v-model="payment.percentage" type="number"/>
                        </b-form-group>
                        <b-form-group label="Cantidad Gastos">
                            <b-form-input v-model="payment.expenses" type="number"/>
                        </b-form-group>
                        <b-form-group label="Tipo de Camión">
                            <b-form-select 
                                v-model="truck_type" 
                                :options="options.truck_types"
                            >
                            </b-form-select>
                        </b-form-group>
                    </div>
                </div>
            </b-card-body>
        </b-card>
        <b-card>    
            <b-card-body>
                <div class="col-md-12 col-sm-12 col-xs-12">
                    <b-form-group label="Destinos">
                        <div class="input-group mb-3">
                            <vue-bootstrap-typeahead
                                v-model="destination_selected"
                                :data="options.destinations.map(e => { return e.name})"
                            />
                            <div class="input-group-append">
                                <button class="btn btn-outline-secondary" type="button" @click="addDestination()"><font-awesome-icon icon="plus" /></button>
                            </div>
                        </div>
                    </b-form-group>
                </div>
            </b-card-body>
        </b-card>
        <b-card id="print-payment">    
            <b-card-body>
                <component-datepicker
                    :focus="false"
                    lang="es"
                    valueType="format" 
                    format="DD-MM-YYYY"
                    v-model="payment.date_range"
                    placeholder="Seleccione rango de fecha ..."
                    range>
                </component-datepicker>
                <div class="row">
                    <div class="col-md-8 col-sm-9 col-xs-9">
                        <b-table 
                            striped 
                            hover 
                            :items="destinations" 
                            :fields="destination_fields"
                        > 

                            <template v-slot:cell(actions)="row" class="btn-remove-destination">
                                <b-button size="sm" class="mr-1" variant="danger" @click="deleteDestination(row.item.index)">
                                    <b-icon icon="trash-fill"></b-icon>
                                </b-button>
                            </template>    
                        </b-table>
                    </div>

                    <div class="col-md-4 col-sm-3 col-xs-3">
                        <b-form-group label="Precio diesel">
                            <b-form-input v-model="diesel_price" type="number" ref="diesel_price"/>
                        </b-form-group>

                        <b-form-group label="Piloto">
                            <b-form-select 
                                v-model="pilot" 
                                :options="options.pilots"
                                :placeholder="'Seleccione un piloto'"
                            >
                            </b-form-select>
                        </b-form-group>
                        
                        <b-form-group label="Total">
                            <b-form-input 
                                v-model="payment.total"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <b-form-group :label="`${payment.taxes_percentage} %`">
                            <b-form-input 
                                v-model="payment.total_taxes_percentage"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <hr>
                        <b-form-group :label="`${payment.percentage} %`">
                            <b-form-input 
                                v-model="payment.total_percentage"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <b-form-group :label="'Pago'">
                            <b-form-input 
                                v-model="payment.pilot_salary"
                                type="number"
                            />
                        </b-form-group>
                        <b-form-group :label="'Pago'">
                            <b-form-input 
                                v-model="payment.pilot_payment"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <hr>
                        <b-form-group :label="'Gastos'">
                            <b-form-input 
                                v-model="payment.total_expent"
                                type="number"
                            />
                        </b-form-group>
                        <b-form-group :label="`${this.payment.expenses} - ${this.payment.total_expent}`">
                            <b-form-input 
                                v-model="payment.total_discount"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <b-form-group v-if="payment.expenses != payment.total_discount">
                            <b-form-textarea
                                label="Detalle Gastos:"
                                id="textarea"
                                v-model="payment.expenses_details"
                                placeholder="Ingrese detalle de gastos"
                                rows="3"
                            >
                            </b-form-textarea>
                        </b-form-group>
                        <hr>
                        <b-form-group :label="'Adiciones'">
                            <b-form-input 
                                v-model="payment.total_extras"
                                type="number"
                            />
                        </b-form-group>
                        <b-form-group v-if="payment.total_extras > 0">
                            <b-form-textarea
                                label="Detalle Adiciones:"
                                id="textarea"
                                v-model="payment.additions_details"
                                placeholder="Ingrese detalle de adiciones"
                                rows="3"
                            >
                            </b-form-textarea>
                        </b-form-group>
                        <hr>
                        <b-form-group :label="'Total Pago'">
                            <b-form-input 
                                v-model="payment.final"
                                type="number"
                                disabled
                            />
                        </b-form-group>
                        <button type="button" id="btn-pay" class="btn btn-success btn-lg btn-block" @click="print">Pagar</button>
                    </div>
                </div>
            </b-card-body>
        </b-card>
    </section>
</template>