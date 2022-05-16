import appFinanceExpedituresList  from 'vueApp/components/component-expeditures-list.vue'
import appFinanceExpedituresNew   from 'vueApp/finance/expeditures/apps/new.vue'
import appFinanceExpedituresShow from 'vueApp/finance/expeditures/apps/show.vue'

const routes =  [
    {
        path: "/finance/expeditures",
        component: appFinanceExpedituresList,
        props: {
            app_module: 'finance',
        }
    },
    {
        path: "/finance/expeditures/new",
        component: appFinanceExpedituresNew
    },
    {
        path: "/finance/expeditures/:id",
        component: appFinanceExpedituresShow
    }
]

export default routes;