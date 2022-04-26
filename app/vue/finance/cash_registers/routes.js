import appCashRegisterList  from 'vueApp/finance/cash_registers/apps/list.vue'
import appCashRegisterShow from 'vueApp/finance/cash_registers/apps/show.vue'

const routes =  [
    {
        path: "/finance/cash_registers",
        component: appCashRegisterList
    },
    {
        path: "/finance/cash_registers/:id",
        component: appCashRegisterShow
    }
]

export default routes;