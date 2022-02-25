import appCatalogExpeditureTypeList  from './apps/list.vue'
import appCatalogExpeditureTypeNew   from './apps/new.vue'
import appCatalogExpeditureTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/catalog/product_transaction_types",
        component: appCatalogExpeditureTypeList
    },
    {
        path: "/catalog/product_transaction_types/new",
        component: appCatalogExpeditureTypeNew
    },
    {
        path: "/catalog/product_transaction_types/:id",
        component: appCatalogExpeditureTypeShow
    }
]

export default routes;