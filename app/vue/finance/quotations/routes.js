import appQuotationsList  from 'vueApp/finance/quotations/apps/list.vue'
import appQuotationsNew   from 'vueApp/finance/quotations/apps/new.vue'
import appQuotationsShow from 'vueApp/finance/quotations/apps/show.vue'


const routes =  [
    {
        path: "/finance/quotations",
        component: appQuotationsList
    },
    {
        path: "/finance/quotations/new",
        component: appQuotationsNew
    },
    {
        path: "/finance/quotations/:id",
        component: appQuotationsShow
    }
]

export default routes;