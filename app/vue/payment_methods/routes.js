import appPaymentMethodsList  from './apps/list.vue'
import appPaymentMethodsNew   from './apps/new.vue'
import appPaymentMethodsShow from './apps/show.vue'


const routes =  [
    {
        path: "/payment_methods",
        component: appPaymentMethodsList
    },
    {
        path: "/payment_methods/new",
        component: appPaymentMethodsNew
    },
    {
        path: "/payment_methods/:id",
        component: appPaymentMethodsShow
    }
]

export default routes;