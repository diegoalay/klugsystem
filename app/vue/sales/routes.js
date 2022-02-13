import appSalesList  from './apps/list.vue'
import appSalesNew   from './apps/new.vue'
import appSalesShow from './apps/show.vue'


const routes =  [
    {
        path: "/sales",
        component: appSalesList
    },
    {
        path: "/sales/new",
        component: appSalesNew
    },
    {
        path: "/sales/:id",
        component: appSalesShow
    }
]

export default routes;