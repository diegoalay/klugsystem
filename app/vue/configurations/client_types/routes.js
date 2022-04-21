import appConfigurationsClientTypeList  from './apps/list.vue'
import appConfigurationsClientTypeNew   from './apps/new.vue'
import appConfigurationsClientTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/configurations/client_types",
        component: appConfigurationsClientTypeList
    },
    {
        path: "/configurations/client_types/new",
        component: appConfigurationsClientTypeNew
    },
    {
        path: "/configurations/client_types/:id",
        component: appConfigurationsClientTypeShow
    }
]

export default routes;