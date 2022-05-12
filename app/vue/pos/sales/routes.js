import appPosList  from 'vueApp/pos/sales/apps/list.vue'
import appPosNew  from 'vueApp/components/component-sale.vue'
import appPosShow from 'vueApp/pos/sales/apps/show.vue'


const routes =  [
    {
        path: "/pos/sales",
        component: appPosList
    },
    {
        path: "/pos/sales/new",
        component: appPosNew,
        props: { cash_register: true, app_module: 'pos' }
    },
    {
        path: "/pos/sales/:id",
        component: appPosShow
    }
]

export default routes;