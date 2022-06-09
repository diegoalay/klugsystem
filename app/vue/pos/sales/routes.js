import appPosSaleList  from 'vueApp/components/sales/component-sales-list.vue'
import appPosSaleNew  from 'vueApp/components/sales/component-sale.vue'
import appPosSaleShow from 'vueApp/components/sales/component-sale-show.vue'


const routes =  [
    {
        path: "/pos/sales",
        component: appPosSaleList,
        props: {
            app_module: 'pos',
            validateCashRegister: true,
            origin: 'sale'
        }
    },
    {
        path: "/pos/sales/new",
        component: appPosSaleNew,
        props: {
            cash_register: true,
            app_module: 'pos',
            buttonFinishHeader: 'Terminar venta'
        }
    },
    {
        path: "/pos/sales/:id",
        component: appPosSaleShow,
        props: {
            app_module: 'pos',
            controller: 'sales'
        }
    }
]

export default routes;