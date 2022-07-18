import appPurchasesBook  from 'vueApp/books/apps/pruchases.vue'
import appSalesBook  from 'vueApp/books/apps/sales.vue'


const routes =  [
    {
        path: "/books/purchases",
        component: appPurchasesBook
    },
    {
        path: "/books/sales",
        component: appSalesBook
    }
]

export default routes;