import appConfigurationsEventTypeList  from './apps/list.vue'
import appConfigurationsEventTypeNew   from './apps/new.vue'
import appConfigurationsEventTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/configurations/event_types",
        component: appConfigurationsEventTypeList
    },
    {
        path: "/configurations/event_types/new",
        component: appConfigurationsEventTypeNew
    },
    {
        path: "/configurations/event_types/:id",
        component: appConfigurationsEventTypeShow
    }
]

export default routes;