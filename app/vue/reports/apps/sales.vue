<script type="text/javascript">
import componentSalesList  from 'vueApp/components/sales/component-sales-list.vue'

export default {
    components: {
        'component-sales-list': componentSalesList
    },
    data() {
        return {
            summary: {},
            initFilters: null
        }
    },
    mounted() {
        const date = new Date()
        this.initFilters = {
            date_range: [
                new Date(date.getFullYear(), date.getMonth(), 1),
                new Date(date.getFullYear(), date.getMonth(), this.date.daysInMonth(date.getMonth()+1, date.getFullYear()))
            ]
        }
    },
    methods: {
        changeSummary(filters){
            this.storage.local('reports/sales', filters)

            const url = this.url.reports('sales')
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
                            <h3> {{ summary.interests }} </h3>
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
                            <h3> {{ summary.discounts }} </h3>
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
                            <h3> {{ summary.invalid_sales }} </h3>
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
                            <h3> {{ summary.valid_sales }} </h3>
                        </b-col>
                    </b-row>
                </b-card>
            </b-col>
        </b-row>
        <component-sales-list
            v-if="initFilters"
            :hideHeader="true"
            app_module='reports'
            :userCreatorTypes="true"
            :initFilters="initFilters"
            @change="changeSummary"
            :init-filters="storage.local('reports/sales')"
        >
        </component-sales-list>
    </section>
</template>