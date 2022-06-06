import appBillList  from 'vueApp/components/sales/component-sales-list.vue'
import appBillNew  from 'vueApp/finance/bills/apps/new.vue'
import appBillShow from 'vueApp/components/sales/component-sale-show.vue'


const routes =  [
    {
        path: "/finance/bills",
        component: appBillList,
        props: {
            app_module: 'finance',
            controller: 'bills',
            userCreatorTypes: true,
            titleHeader: 'Facturas',
            origin: 'bill'
        }
    },
    {
        path: "/finance/bills/new",
        component: appBillNew,
        props: {
            app_module: 'finance'
        }
    },
    {
        path: "/finance/bills/:id",
        component: appBillShow,
        props: {
            app_module: 'finance',
            controller: 'bills'
        }
    }
]

export default routes;