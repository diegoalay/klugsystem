import appBillingFieldsList  from 'vueApp/administration/billing_fields/apps/list.vue'
import appBillingFieldsNew   from 'vueApp/administration/billing_fields/apps/new.vue'
import appBillingFieldsShow from 'vueApp/administration/billing_fields/apps/show.vue'

const routes =  [
    {
        path: "/administration/billing_fields",
        component: appBillingFieldsList
    },
    {
        path: "/administration/billing_fields/new",
        component: appBillingFieldsNew
    },
    {
        path: "/administration/billing_fields/:id",
        component: appBillingFieldsShow
    }
]

export default routes;