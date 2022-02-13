import appCatalogEventTypeList  from './apps/list.vue'
import appCatalogEventTypeNew   from './apps/new.vue'
import appCatalogEventTypeShow from './apps/show.vue'

const routes =  [
    {
        path: "/catalog/event_types",
        component: appCatalogEventTypeList
    },
    {
        path: "/catalog/event_types/new",
        component: appCatalogEventTypeNew
    },
    {
        path: "/catalog/event_types/:id",
        component: appCatalogEventTypeShow
    }
]

export default routes;