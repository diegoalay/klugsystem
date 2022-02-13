import appProductsList  from './apps/list.vue'
import appProductsNew   from './apps/new.vue'
import appProductsShow from './apps/show.vue'


const routes =  [
    {
        path: "/products",
        component: appProductsList
    },
    {
        path: "/products/new",
        component: appProductsNew
    },
    {
        path: "/products/:id",
        component: appProductsShow
    }
]

export default routes;