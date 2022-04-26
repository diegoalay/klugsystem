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
                    for (let key in result.data) {
                        this.$set(this.cash_register, key, result.data[key])
                    }
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
</template>