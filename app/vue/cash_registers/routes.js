import appCashRegisterList  from './apps/list.vue'
import appCashRegisterNew   from './apps/new.vue'
import appCashRegisterShow from './apps/show.vue'
import appCashRegister from './apps/cash_register.vue'

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
    },
    {
        path: "/profile/cash_register",
        component: appCashRegister
    }
]

export default routes;