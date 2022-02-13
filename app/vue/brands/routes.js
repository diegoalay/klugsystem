import appBrandsList  from './apps/list.vue'
import appBrandsNew   from './apps/new.vue'
import appBrandsShow from './apps/show.vue'

const routes =  [
    {
        path: "/brands",
        component: appBrandsList
    },
    {
        path: "/brands/new",
        component: appBrandsNew
    },
    {
        path: "/brands/:id",
        component: appBrandsShow
    }
]

export default routes;