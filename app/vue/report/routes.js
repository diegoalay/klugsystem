import appReportSale from 'vueApp/report/sales.vue'


const routes =  [
    {
        path: "/reports/sales",
        component: appReportSale,
        props: {
            app_module: 'pos'
        }
    }
]

export default routes;