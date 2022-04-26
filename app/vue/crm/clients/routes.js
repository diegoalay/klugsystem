import appClientsList  from 'vueApp/crm/clients/apps/list.vue'
import appClientsNew   from 'vueApp/crm/clients/apps/new.vue'
import appClientsShow from 'vueApp/crm/clients/apps/show.vue'

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