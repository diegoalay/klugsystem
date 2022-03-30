import appSalesList  from 'vueApp/finance/sales/apps/list.vue'
import appSalesNew   from 'vueApp/finance/sales/apps/new.vue'
import appSalesShow from 'vueApp/finance/sales/apps/show.vue'


const routes =  [
    {
        path: "/finance/sales",
        component: appSalesList
    },
    {
        path: "/finance/sales/new",
        component: appSalesNew
    },
    {
        path: "/finance/sales/:id",
        component: appSalesShow
    }
]

export default routes;