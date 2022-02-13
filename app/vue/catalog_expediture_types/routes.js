import appCatalogExpeditureTypeList  from './apps/list.vue'
import appCatalogExpeditureTypeNew   from './apps/new.vue'
import appCatalogExpeditureTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/catalog/expediture_types",
        component: appCatalogExpeditureTypeList
    },
    {
        path: "/catalog/expediture_types/new",
        component: appCatalogExpeditureTypeNew
    },
    {
        path: "/catalog/expediture_types/:id",
        component: appCatalogExpeditureTypeShow
    }
]

export default routes;