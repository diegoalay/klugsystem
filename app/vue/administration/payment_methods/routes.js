import appPaymentMethodsList  from './apps/list.vue'
import appPaymentMethodsNew   from './apps/new.vue'
import appPaymentMethodsShow from './apps/show.vue'


const routes =  [
    {
        path: "/administration/payment_methods",
        component: appPaymentMethodsList
    },
    {
        path: "/administration/payment_methods/new",
        component: appPaymentMethodsNew
    },
    {
        path: "/administration/payment_methods/:id",
        component: appPaymentMethodsShow
    }
]

export default routes;