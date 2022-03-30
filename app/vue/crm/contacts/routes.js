import appContactsList  from 'vueApp/crm/contacts/apps/list.vue'
import appContactsNew   from 'vueApp/crm/contacts/apps/new.vue'
import appContactsShow from 'vueApp/crm/contacts/apps/show.vue'

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