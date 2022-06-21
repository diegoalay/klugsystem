<script type="text/javascript">
import componentSalesList  from 'vueApp/components/sales/component-sales-list.vue'

export default {
    components: {
        'component-sales-list': componentSalesList
    },
    data() {
        return {
            summary: {
                total: 0
            },
            initFilters: null,
            filters: {}
        }
    },
    mounted() {
        let filters = {}
        for(let key in this.storage.local('reports/sales')) {
            const value = this.storage.local('reports/sales')[key]

            if (value) {
                filters[key] = value
            }
        }

        if (!filters['date_range'] || filters['date_range'].length === 0) {
            const date = new Date()
            filters['date_range'] =  [
                new Date(date.getFullYear(), date.getMonth(), 1),
                new Date(date.getFullYear(), date.getMonth(), this.date.daysInMonth(date.getMonth()+1, date.getFullYear()))
            ]
        }

        this.initFilters = JSON.parse(JSON.stringify(filters))
    },
    methods: {
        changeSummary(filters){
            this.filters = filters

            this.storage.local('reports/sales', filters)

            const url = this.getUrl('json')
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.summary = result.data
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getUrl(type){
            let url = this.url.reports('sales').filters(this.filters).paginate(false)

            return url.toString(type)
        }
    }
}
</script>

<template>
    <section>
        <b-row md="12" sm="12">
            <b-col md="3" sm="12">
                <b-card  title="Intereses" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="text-left">
                            <h5 class="text-success">
                                <font-awesome-icon icon="arrow-up"/> {{ summary.interests_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ this.number.formatCurrency(summary.interests) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col md="3" sm="12">
                <b-card  title="Descuentos" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="text-left">
                            <h5 class="text-danger">
                                <font-awesome-icon icon="arrow-down"/> {{ summary.discounts_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ this.number.formatCurrency(summary.discounts) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col md="3" sm="12">
                <b-card  title="Ventas anuladas" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="text-left">
                            <h5 class="text-danger">
                                <font-awesome-icon icon="arrow-down"/> {{ summary.invalid_sales_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ this.number.formatCurrency(summary.invalid_sales) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col md="3" sm="12">
                <b-card title="Ventas realizadas" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="dashboard-counter text-left">
                            <h5 class="text-success">
                                <font-awesome-icon icon="arrow-up"/> {{ summary.valid_sales_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ this.number.formatCurrency(summary.valid_sales) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
        </b-row>
        <component-header-form v-if="summary.total > 0">
            <slot name="buttons">
                <b-button variant="outline-danger" @click="tools.printSales(getUrl('pdf'))" class="mb-2">
                    <font-awesome-icon icon="file-pdf" />
                    {{ 'Fact. electrónicas' }}
                </b-button>
            </slot>
        </component-header-form>
        <component-sales-list
            v-if="initFilters !== null"
            :hideHeader="true"
            app_module='reports'
            :userCreatorTypes="true"
            @change="changeSummary"
            :init-filters="initFilters"
        >
        </component-sales-list>
    </section>
</template>