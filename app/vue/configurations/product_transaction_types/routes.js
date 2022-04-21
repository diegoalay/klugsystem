import appConfigurationsExpeditureTypeList  from './apps/list.vue'
import appConfigurationsExpeditureTypeNew   from './apps/new.vue'
import appConfigurationsExpeditureTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/configurations/product_transaction_types",
        component: appConfigurationsExpeditureTypeList
    },
    {
        path: "/configurations/product_transaction_types/new",
        component: appConfigurationsExpeditureTypeNew
    },
    {
        path: "/configurations/product_transaction_types/:id",
        component: appConfigurationsExpeditureTypeShow
    }
]

export default routes;