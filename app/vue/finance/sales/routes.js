import appSalesList  from 'vueApp/finance/sales/apps/list.vue'
import appSalesNew  from 'vueApp/components/component-sale.vue'
import appSalesShow from 'vueApp/finance/sales/apps/show.vue'


const routes =  [
    {
        path: "/finance/sales",
        component: appSalesList
    },
    {
        path: "/finance/sales/new",
        component: appSalesNew,
        props: { app_module: 'finance' }
    },
    {
        path: "/finance/sales/:id",
        component: appSalesShow
    }
]

export default routes;