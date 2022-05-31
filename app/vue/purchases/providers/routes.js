import appProvidersList  from 'vueApp/purchases/providers/apps/list.vue'
import appProvidersNew   from 'vueApp/purchases/providers/apps/new.vue'
import appProvidersShow from 'vueApp/purchases/providers/apps/show.vue'

const routes =  [
    {
        path: "/purchases/providers",
        component: appProvidersList
    },
    {
        path: "/purchases/providers/new",
        component: appProvidersNew
    },
    {
        path: "/purchases/providers/:id",
        component: appProvidersShow
    }
]

export default routes;