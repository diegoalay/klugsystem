import appUsersList  from 'vueApp/administration/users/apps/list.vue'
import appUsersNew   from 'vueApp/administration/users/apps/new.vue'
import appUsersShow from 'vueApp/administration/users/apps/show.vue'

const routes =  [
    {
        path: "/administration/users",
        component: appUsersList
    },
    {
        path: "/administration/users/new",
        component: appUsersNew
    },
    {
        path: "/administration/users/:id",
        component: appUsersShow
    }
]

export default routes;