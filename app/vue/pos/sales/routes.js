import appPosSaleList  from 'vueApp/components/component-sales-list.vue'
import appPosSaleNew  from 'vueApp/components/component-sale.vue'
import appPosSaleShow from 'vueApp/pos/sales/apps/show.vue'


const routes =  [
    {
        path: "/pos/sales",
        component: appPosSaleList,
        props: {
            app_module: 'pos'
        }
    },
    {
        path: "/pos/sales/new",
        component: appPosSaleNew,
        props: {
            cash_register: true,
            app_module: 'pos'
        }
    },
    {
        path: "/pos/sales/:id",
        component: appPosSaleShow
    }
]

export default routes;