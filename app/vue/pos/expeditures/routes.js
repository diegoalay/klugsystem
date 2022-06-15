import appPosExpedituresList  from 'vueApp/components/component-expeditures-list.vue'
import appPosExpedituresNew   from 'vueApp/pos/expeditures/apps/new.vue'
import appPosExpedituresShow from 'vueApp/pos/expeditures/apps/show.vue'

const routes =  [
    {
        path: "/pos/expeditures",
        component: appPosExpedituresList,
        props: {
            app_module: 'pos',
            validateCashRegister: true
        }
    },
    {
        path: "/pos/expeditures/new",
        component: appPosExpedituresNew
    },
    {
        path: "/pos/expeditures/:id",
        component: appPosExpedituresShow,
    }
]

export default routes;