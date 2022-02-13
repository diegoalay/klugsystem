import appClientsList  from './apps/list.vue'
import appClientsNew   from './apps/new.vue'
import appClientsShow from './apps/show.vue'

const routes =  [
    {
        path: "/clients",
        component: appClientsList
    },
    {
        path: "/clients/new",
        component: appClientsNew
    },
    {
        path: "/clients/:id",
        component: appClientsShow
    }
]

export default routes;