import appBillTemplatesList  from 'vueApp/finance/bill_templates/apps/list.vue'
import appBillTemplatesNew   from 'vueApp/finance/bill_templates/apps/new.vue'
import appBillTemplatesShow from 'vueApp/finance/bill_templates/apps/show.vue'

const routes =  [
    {
        path: "/finance/bill_templates",
        component: appBillTemplatesList
    },
    {
        path: "/finance/bill_templates/new",
        component: appBillTemplatesNew
    },
    {
        path: "/finance/bill_templates/:id",
        component: appBillTemplatesShow
    }
]

export default routes;