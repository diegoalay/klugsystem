<script type="text/javascript">
import componentSaleDetailsList  from 'vueApp/reports/components/sale-details-list.vue'

export default {
    components: {
        'component-sale-details-list': componentSaleDetailsList
    },
    data() {
        return {
            summary: {},
            dateRange: null
        }
    },
    mounted() {
        const date = new Date()
        this.dateRange = [
            new Date(date.getFullYear(), date.getMonth(), 1),
            new Date(date.getFullYear(), date.getMonth(), this.date.daysInMonth(date.getMonth()+1, date.getFullYear()))
        ]
    },
    methods: {
        changeSummary(filters){
            this.storage.local('reports/sale_details', filters)

            const url = this.url.reports('sale_details')
            .filters(filters)
            .paginate(false)

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.summary = result.data
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
    <section>
        <b-row>
            <b-col cols="3">
                <b-card  title="Intereses" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="text-left">
                            <h5 class="text-info">
                                <font-awesome-icon icon="arrow-up"/> {{ summary.interests_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ number.formatCurrency(summary.interests) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col cols="3">
                <b-card  title="Descuentos" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="text-left">
                            <h5 class="text-danger">
                                <font-awesome-icon icon="arrow-down"/> {{ summary.discounts_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ number.formatCurrency(summary.discounts) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col cols="3">
                <b-card title="# Artículos/Servicios" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="dashboard-counter text-left">
                            <h5 class="text-dark">
                                <font-awesome-icon icon="tags"/>
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ number.formatCurrency(summary.products_count) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
            <b-col cols="3">
                <b-card title="Total Ventas" class="dashboard-top-box">
                    <b-row>
                        <b-col md="3" sm="3" class="dashboard-counter text-left">
                            <h5 class="text-success">
                                <font-awesome-icon icon="coins"/> {{ summary.valid_sales_count }}
                            </h5>
                        </b-col>
                        <b-col md="9" sm="9" class="dashboard-value text-right">
                            <h3> {{ number.formatCurrency(summary.valid_sales) }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
        </b-row>

        <component-sale-details-list
            v-if="dateRange"
            app_module='reports'
            :userCreatorTypes="true"
            :branchOffices="true"
            :date-range="dateRange"
            @change="changeSummary"
            :init-filters="storage.local('reports/sale_details')"
        >
        </component-sale-details-list>
    </section>
</template>