import appClientsList  from './apps/list.vue'
import appClientsNew   from './apps/new.vue'
import appClientsShow from './apps/show.vue'

const routes =  [
    {
        path: "/crm/clients",
        component: appClientsList
    },
    {
        path: "/crm/clients/new",
        component: appClientsNew
    },
    {
        path: "/crm/clients/:id",
        component: appClientsShow
    }
]

export default routes;