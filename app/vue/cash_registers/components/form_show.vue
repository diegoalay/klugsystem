<script>
import componentSalesList from './sales-list.vue'
import componentExpedituresList from './expeditures-list.vue'

export default {
    props: {
        cash_register: {
            required: true,
            type: Object
        }
    },
    components: {
        'component-sales-list': componentSalesList,
        'component-expeditures-list': componentExpedituresList,
    },
    data() {
        return {
          chartOptions: {
            chart: {
              type: 'pie',
            },
            labels: this.cash_register.chart.labels,
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
        }
    },
    mounted() {},
    methods: {
        onSubmit(){
            this.putForm()
        },
        putForm(close = false){
            const url = this.url.build('cash_registers/:id', {id: this.cash_register.id})

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
                    for (let key in result.successful.data) {
                        this.$set(this.cash_register, key, result.data[key])
                    }

                    if (close) {
                        this.$toast.success('Caja cerrada exitosamente.')
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
        closeCashRegister(){
            this.putForm(true)
        }
    }
}
</script>

<template>
    <b-card no-body>
        <b-tabs card pills fill>
            <b-tab title="Formulario" fill active>
                <b-container>
                    <b-form @submit.prevent="onSubmit">
                        <b-container>
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
                        </b-container>

                        <b-container>
                            <b-button type="submit" variant="primary">Guardar</b-button>
                            <b-button @click.prevent="closeCashRegister()" variant="dark">Cerrar caja</b-button>
                        </b-container>
                    </b-form>
                </b-container>
            </b-tab>
            <b-tab title="Resumen">
                <b-container class="text-center">
                    <apexchart type="pie" width="380" :options="chartOptions" :series="cash_register.chart.series"></apexchart>
                </b-container>
            </b-tab>
            <b-tab title="Listados">
                <b-tabs v-if="tools.isMobile" card pills fill content-class="justified">
                    <b-tab title="Ventas" active>
                        <component-sales-list :cash_register="cash_register" />
                    </b-tab>
                    <b-tab title="Gastos">
                        <component-expeditures-list :cash_register="cash_register" />
                    </b-tab>
                </b-tabs>
            </b-tab>
        </b-tabs>
    </b-card>
</template>