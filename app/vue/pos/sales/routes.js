import appPosList  from 'vueApp/pos/sales/apps/list.vue'
import appPosNew   from 'vueApp/pos/sales/apps/new.vue'
import appPosShow from 'vueApp/pos/sales/apps/show.vue'


const routes =  [
    {
        path: "/pos/sales",
        component: appPosList
    },
    {
        path: "/pos/sales/new",
        component: appPosNew
    },
    {
        path: "/pos/sales/:id",
        component: appPosShow
    }
]

export default routes;