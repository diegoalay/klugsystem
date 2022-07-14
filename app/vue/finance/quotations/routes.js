import appQuotationsList  from 'vueApp/finance/quotations/apps/list.vue'
import appQuotationsNew   from 'vueApp/components/sales/component-sale.vue'
import appQuotationsShow from 'vueApp/components/sales/component-sale-show.vue'

const routes =  [
    {
        path: "/finance/quotations",
        component: appQuotationsList
    },
    {
        path: "/finance/quotations/new",
        component: appQuotationsNew,
        props: {
            quotation: true,
            app_module: 'finance',
            controller: 'quotations',
            buttonFinishHeader: 'Terminar cotización',
            successMessage: 'Cotización creada exitosamente.',
            titleHeader: 'Cotización'
        }
    },
    {
        path: "/finance/quotations/:id",
        component: appQuotationsShow,
        props: {
            app_module: 'finance',
            controller: 'quotations'
        }
    }
]

export default routes;