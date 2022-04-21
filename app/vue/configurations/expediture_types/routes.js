import appConfigurationsExpeditureTypeList  from './apps/list.vue'
import appConfigurationsExpeditureTypeNew   from './apps/new.vue'
import appConfigurationsExpeditureTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/configurations/expediture_types",
        component: appConfigurationsExpeditureTypeList
    },
    {
        path: "/configurations/expediture_types/new",
        component: appConfigurationsExpeditureTypeNew
    },
    {
        path: "/configurations/expediture_types/:id",
        component: appConfigurationsExpeditureTypeShow
    }
]

export default routes;