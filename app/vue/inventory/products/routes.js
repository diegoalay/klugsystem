import appProductsList  from 'vueApp/inventory/products/apps/list.vue'
import appProductsNew   from 'vueApp/inventory/products/apps/new.vue'
import appProductsShow from 'vueApp/inventory/products/apps/show.vue'


const routes =  [
    {
        path: "/inventory/products",
        component: appProductsList
    },
    {
        path: "/inventory/products/new",
        component: appProductsNew
    },
    {
        path: "/inventory/products/:id",
        component: appProductsShow
    }
]

export default routes;
