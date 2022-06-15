import appBillList  from 'vueApp/components/sales/component-sales-list.vue'
import appBillNew  from 'vueApp/components/sales/component-sale.vue'
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
            buttonHeader: 'Facturar',
            origin: 'bill',
            hiddenColumns: ['received_amount', 'change']
        }
    },
    {
        path: "/finance/bills/new",
        component: appBillNew,
        props: {
            app_module: 'finance',
            controller: 'bills',
            buttonFinishHeader: 'Terminar factura',
            successMessage: 'Factura creada exitosamente.',
            manualSale: true,
            titleHeader: 'Facturación',
            origin: 'bill'
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