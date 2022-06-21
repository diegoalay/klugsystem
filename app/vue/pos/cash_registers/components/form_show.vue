<script>
import componentExpedituresList from 'vueApp/components/component-expeditures-list.vue'
import componentSalesList  from 'vueApp/components/sales/component-sales-list.vue'

export default {
    props: {},
    components: {
        'component-sales-list': componentSalesList,
        'component-expeditures-list': componentExpedituresList,
    },
    data() {
        return {
            summary: {},
            cash_register: {
                id: null,
                chart: {}
            },
            chartOptions: {
                chart: {
                type: 'pie',
                },
                labels: [],
                responsive: [{
                    breakpoint: 480,
                    options: {
                        chart: {
                        width: 200
                        },
                        legend: {
                        position: 'bottom'
                        }
                    }
                }]
            },
            tabIndex: 0
        }
    },
    mounted() {
        this.getSummary()

        this.cash_register = JSON.parse(JSON.stringify(this.store.global.cash_register))

        this.$set(this.chartOptions, 'labels', this.cash_register.chart.labels)
    },
    methods: {
        onSubmit(){
            this.putForm()
        },
        putForm(close = false){
            const url = this.url.pos('cash_register')

            let cash_register = this.cash_register
            if (close) {
                cash_register = {
                    ...cash_register,
                    close: true
                }
            }

            let form = {
                cash_register
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    for (let key in result.data) {
                        this.$set(this.cash_register, key, result.data[key])
                    }

                    if (close) {
                        this.$toast.success('Caja cerrada exitosamente.')

                        this.$set(this.store.global, 'cash_register', { id: null })
                    } else {
                        this.$toast.success('Caja actualizada exitosamente.')
                    }
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getSummary(){
            this.loading = true

            const url = this.url.build('dashboard')
            this.http.get(url).then(response => {
                if (response.successful) {
                    this.summary = response.data
                } else {
                    this.$toast.error(result.error.message)
                }

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },
        closeCashRegister(){
            this.putForm(true)
        }
    }
}
</script>

<template>
    <div>
        <b-row>
            <b-col col="4">
                <b-card  title="Gastos" class="dashboard-top-box">
                    <b-row>
                        <b-col md="4" sm="4" class="text-left">
                            <h5 class="text-danger">
                                <font-awesome-icon icon="arrow-down"/> {{ summary.expeditures_count }}
                            </h5>
                        </b-col>
                        <b-col md="7" sm="7" class="dashboard-value text-right">
                            <h3> Q. {{ summary.expeditures_total }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col col="4">
                <b-card title="Ventas" class="dashboard-top-box">
                    <b-row>
                        <b-col md="4" sm="4" class="dashboard-counter text-left">
                            <h5 class="text-success">
                                <font-awesome-icon icon="arrow-up"/> {{ summary.sales_count }}
                            </h5>
                        </b-col>
                        <b-col md="8" sm="8" class="dashboard-value text-right">
                            <h3> Q. {{ summary.sales_total }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col col="4">
                <b-card title="Total" class="dashboard-top-box">
                    <b-row>
                        <b-col md="4" sm="4" class="dashboard-counter text-left">
                            <h5 class="text-info">
                                <font-awesome-icon icon="dollar-sign"/>
                            </h5>
                        </b-col>
                        <b-col md="8" sm="8" class="dashboard-value text-right">
                            <h3> Q. {{ summary.final_value }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
        </b-row>
        <b-card no-body>
            <b-tabs v-model="tabIndex" card>
                <b-tab title="Detalles">
                    <b-row>
                        <b-col md="8" sm="12">
                            <b-card>
                                <b-card-body>
                                    <b-form @submit.prevent="onSubmit">
                                        <b-form-group>
                                            <label> Valor inicial <sup class="text-danger">*</sup> </label>

                                            <b-form-input
                                                v-model="cash_register.initial_value"
                                                type="number"
                                                placeholder=""
                                                required
                                            >
                                            </b-form-input>
                                        </b-form-group>

                                        <b-form-group label="Valor final">
                                            <b-form-input
                                                disabled
                                                readonly
                                                :value="cash_register.final_value"
                                                type="number"
                                                placeholder=""
                                                required
                                            >
                                            </b-form-input>
                                        </b-form-group>

                                        <div class="text-right">
                                            <b-button type="submit" variant="primary">Guardar</b-button>
                                            <b-button @click.prevent="closeCashRegister()" variant="dark">Cerrar caja</b-button>
                                        </div>
                                    </b-form>
                                </b-card-body>
                            </b-card>
                        </b-col>

                        <b-col class="text-center" md="4" sm="12">
                            <b-card>
                                <b-card-body>
                                    <apexchart v-if="cash_register.id" type="pie" :options="chartOptions" :series="cash_register.chart.series"></apexchart>
                                </b-card-body>
                            </b-card>
                        </b-col>
                    </b-row>
                </b-tab>
                <b-tab title="Listado de ventas">
                    <component-sales-list app_module='pos' :hideHeader="true" :cash-register-id="cash_register.id"></component-sales-list>
                </b-tab>
                <b-tab title="Listado de gastos">
                    <component-expeditures-list app_module='pos' :cash-register-id="cash_register.id"></component-expeditures-list>
                </b-tab>
            </b-tabs>
        </b-card>
    </div>
</template>