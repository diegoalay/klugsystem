
<script>
import es from "apexcharts/dist/locales/es.json";

export default {
    props: {
        product: {
            required: true,
            type: Object
        },
        statistics: {
            required: true,
            type: Object
        },
        activeTab: {
            type: Boolean
        }
    },
    components: {

    },
    data() {
        return {
            total: 0,
            loading: false,
            filters: {
                year: this.tools.getCurrentYear(),
                month: this.tools.getCurrentMonth()
            },
            chart: {
                bar: {}
            }
        }
    },
    mounted() {
        this.initChartBar()
    },
    methods: {
        initChartBar(){
            this.$set(this.chart, 'bar', {
                    series: null,
                    options: {
                        chart: {
                            locales: [es],
                            defaultLocale: 'es',
                            height: 450,
                            type: 'bar',
                        },
                        plotOptions: {
                            bar: {
                                borderRadius: 10,
                                dataLabels: {
                                    position: 'bottom', // top, center, bottom
                                },
                            }
                        },
                        dataLabels: {
                            enabled: true,
                            formatter: (val) => {
                                return val;
                            },
                            offsetY: 0,
                            style: {
                                fontSize: '15px',
                                colors: ["#304758"]
                            }
                        },
                        xaxis: {
                            categories: null,
                            position: 'top',
                            axisBorder: {
                                show: false
                            },
                            axisTicks: {
                                show: false
                            },
                            crosshairs: {
                                fill: {
                                    type: 'gradient',
                                    gradient: {
                                        colorFrom: '#D8E3F0',
                                        colorTo: '#BED1E6',
                                        stops: [0, 100],
                                        opacityFrom: 0.4,
                                        opacityTo: 0.5,
                                    }
                                }
                            },
                            tooltip: {
                                enabled: true,
                            }
                        },
                        yaxis: {
                            axisBorder: {
                                show: false
                            },
                            axisTicks: {
                                show: false,
                            },
                            labels: {
                                show: false,
                                formatter: (val) => {
                                    return val;
                                }
                            }

                        },
                        title: {
                            text: '',
                            align: 'center',
                            style: {
                                color: '#444'
                            }
                        },
                        responsive: [
                            {
                                breakpoint: 760,
                                options: {
                                    plotOptions: {
                                        bar: {
                                            horizontal: false
                                        }
                                    },
                                    legend: {
                                        position: "bottom"
                                    }
                                }
                            }
                        ]
                    }
                }
            )

            this.chartData()

            setTimeout(() => {
                this.$refs.salesChart.refresh()
            }, 500);
        },

        chartData(){
            let labels = this.statistics[this.filters.year] ?
            this.statistics[this.filters.year] :
            Array(12).fill(0)

            let categories = this.tools.getMonthsNameList()

            if (this.tools.isMobile()) {
                labels = [labels[this.filters.month]]
                categories = [categories[this.filters.month]]
            }

            this.$set(this.chart.bar.options.xaxis, 'categories', categories)

            this.$set(this.chart.bar, 'series', [{
                name: 'Cantidad',
                data: labels
            }])

            this.total = labels.reduce((previousValue, currentValue) => {
                return previousValue + currentValue;
            })
        },

        chartYears(){
            return Object.keys(this.statistics)
        },

        setBarChartTitle(){
            this.$set(this.chart.bar.options, 'title', `Ventas mensuales año (${this.filters.year})`,) // set chart title
        },

        monthsOptions(){
            let months = this.tools.getMonthsNameList()

            months = months.map((e, index) => {
                return {
                    value: index,
                    text: e
                }
            })

            return months
        }
    },

    watch: {
        activeTab(value){
            if (value) {
                window.dispatchEvent(new Event('resize'))
            }
        }
    }
}
</script>

<template>
    <b-card>
        <b-card-body>
            <b-row v-if="tools.isMobile()">
                <b-col sm="12">
                    <b-form-select
                        v-model="filters.year"
                        :options="chartYears()"
                        @change="chartData()"
                    >
                    </b-form-select>
                </b-col>
                <b-col sm="12">
                    <b-form-select
                        v-model="filters.month"
                        :options="monthsOptions()"
                        @change="chartData()"
                    >
                    </b-form-select>
                </b-col>
                <b-col sm="12">
                    <b-input-group>
                        <template #prepend>
                            <b-input-group-text >Total</b-input-group-text>
                        </template>
                        <b-form-input disabled readonly class="text-right" :value="total"> </b-form-input>
                    </b-input-group>
                </b-col>
            </b-row>
            <b-row v-else>
                <b-col md="7">
                    <b-form-select
                        v-model="filters.year"
                        :options="chartYears()"
                        @change="chartData()"
                    >
                    </b-form-select>
                </b-col>
                <b-col md="5">
                    <b-input-group>
                        <template #prepend>
                            <b-input-group-text >Total</b-input-group-text>
                        </template>
                        <b-form-input disabled readonly class="text-right" :value="total"> </b-form-input>
                    </b-input-group>
                </b-col>
            </b-row>

            <br>
            <br>

            <div class="d-flex justify-content-center">
                <apexchart v-if="chart.bar.series" ref="salesChart" class="align-middle text-center" type="bar" :options="chart.bar.options" :series="chart.bar.series"></apexchart>
            </div>
        </b-card-body>
    </b-card>
</template>