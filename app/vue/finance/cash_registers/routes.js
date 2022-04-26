import appCashRegisterList  from 'vueApp/finance/cash_registers/apps/list.vue'
import appCashRegisterNew   from 'vueApp/finance/cash_registers/apps/new.vue'
import appCashRegisterShow from 'vueApp/finance/cash_registers/apps/show.vue'
import appCashRegister from 'vueApp/finance/cash_registers/apps/cash_register.vue'

const routes =  [
    {
        path: "/cash_registers",
        component: appCashRegisterList
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