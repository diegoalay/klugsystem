import appReportSale from 'vueApp/reports/apps/sales.vue'
import appReportSaleDetails from 'vueApp/reports/apps/sale_details.vue'


const routes =  [
    {
        path: "/reports/sales",
        component: appReportSale
    },
    {
        path: "/reports/sale_details",
        component: appReportSaleDetails
    }
]

export default routes;