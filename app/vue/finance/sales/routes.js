import appSalesList  from 'vueApp/components/sales/component-sales-list.vue'
import appSalesNew  from 'vueApp/components/sales/component-sale.vue'
import appSalesShow from 'vueApp/components/sales/component-sale-show.vue'


const routes =  [
    {
        path: "/finance/sales",
        component: appSalesList,
        props: {
            app_module: 'finance',
            controller: 'sales',
            userCreatorTypes: true,
            origin: 'sale'
        }
    },
    {
        path: "/finance/sales/new",
        component: appSalesNew,
        props: {
            app_module: 'finance',
            buttonFinishHeader: 'Terminar venta',
            successMessage: 'Venta realizada exitosamente.',
            titleHeader: 'Venta'
        }
    },
    {
        path: "/finance/sales/:id",
        component: appSalesShow,
        props: {
            app_module: 'finance',
            controller: 'sales'
        }
    }
]

export default routes;