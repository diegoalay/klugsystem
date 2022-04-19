import appRolesList  from 'vueApp/administration/roles/apps/list.vue'
import appRolesNew   from 'vueApp/administration/roles/apps/new.vue'
import appRolesShow from 'vueApp/administration/roles/apps/show.vue'

const routes =  [
    {
        path: "/administration/roles",
        component: appRolesList
    },
    {
        path: "/administration/roles/new",
        component: appRolesNew
    },
    {
        path: "/administration/roles/:id",
        component: appRolesShow
    }
]

export default routes;