import appCatalogClientTypeList  from './apps/list.vue'
import appCatalogClientTypeNew   from './apps/new.vue'
import appCatalogClientTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/catalog/client_types",
        component: appCatalogClientTypeList
    },
    {
        path: "/catalog/client_types/new",
        component: appCatalogClientTypeNew
    },
    {
        path: "/catalog/client_types/:id",
        component: appCatalogClientTypeShow
    }
]

export default routes;