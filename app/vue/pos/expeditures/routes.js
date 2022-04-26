import appPosExpedituresList  from 'vueApp/pos/expeditures/apps/list.vue'
import appPosExpedituresNew   from 'vueApp/pos/expeditures/apps/new.vue'
import appPosExpedituresShow from 'vueApp/pos/expeditures/apps/show.vue'

const routes =  [
    {
        path: "/pos/expeditures",
        component: appPosExpedituresList
    },
    {
        path: "/pos/expeditures/new",
        component: appPosExpedituresNew
    },
    {
        path: "/pos/expeditures/:id",
        component: appPosExpedituresShow
    }
]

export default routes;