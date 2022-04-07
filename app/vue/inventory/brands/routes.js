import appBrandsList  from 'vueApp/inventory/brands/apps/list.vue'
import appBrandsNew   from 'vueApp/inventory/brands/apps/new.vue'
import appBrandsShow from 'vueApp/inventory/brands/apps/show.vue'

const routes =  [
    {
        path: "/inventory/brands",
        component: appBrandsList
    },
    {
        path: "/inventory/brands/new",
        component: appBrandsNew
    },
    {
        path: "/inventory/brands/:id",
        component: appBrandsShow
    }
]

export default routes;