import appCashRegisterList  from './apps/list.vue'
import appCashRegisterNew   from './apps/new.vue'
import appCashRegisterShow from './apps/show.vue'

const routes =  [
    {
        path: "/cash_registers",
        component: appCashRegisterList
    },
    {
        path: "/cash_registers/new",
        component: appCashRegisterNew
    },
    {
        path: "/cash_registers/:id",
        component: appCashRegisterShow
    }
]

export default routes;