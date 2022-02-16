import appBrandsList  from './apps/list.vue'
import appBrandsNew   from './apps/new.vue'
import appBrandsShow from './apps/show.vue'

const routes =  [
    {
        path: "/expeditures",
        component: appBrandsList
    },
    {
        path: "/expeditures/new",
        component: appBrandsNew
    },
    {
        path: "/expeditures/:id",
        component: appBrandsShow
    }
]

export default routes;