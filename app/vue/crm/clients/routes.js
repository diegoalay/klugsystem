import appClientsList  from 'vueApp/crm/contacts/apps/list.vue'
import appClientsNew   from 'vueApp/crm/contacts/apps/new.vue'
import appClientsShow from 'vueApp/crm/contacts/apps/show.vue'

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