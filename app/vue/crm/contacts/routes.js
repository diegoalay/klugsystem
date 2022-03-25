import appContactsList  from './apps/list.vue'
import appContactsNew   from './apps/new.vue'
import appContactsShow from './apps/show.vue'

const routes =  [
    {
        path: "/crm/contacts",
        component: appContactsList
    },
    {
        path: "/crm/contacts/new",
        component: appContactsNew
    },
    {
        path: "/crm/contacts/:id",
        component: appContactsShow
    }
]

export default routes;