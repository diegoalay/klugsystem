import appBrandsList  from 'vueApp/finance/expeditures/apps/list.vue'
import appBrandsNew   from 'vueApp/finance/expeditures/apps/new.vue'
import appBrandsShow from 'vueApp/finance/expeditures/apps/show.vue'

const routes =  [
    {
        path: "/finance/expeditures",
        component: appBrandsList
    },
    {
        path: "/finance/expeditures/new",
        component: appBrandsNew
    },
    {
        path: "/finance/expeditures/:id",
        component: appBrandsShow
    }
]

export default routes;