import appEmployeesList  from './apps/list.vue'
import appEmployeesNew   from './apps/new.vue'
import appEmployeesShow from './apps/show.vue'

const routes =  [
    {
        path: "/employees",
        component: appEmployeesList
    },
    {
        path: "/employees/new",
        component: appEmployeesNew
    },
    {
        path: "/employees/:id",
        component: appEmployeesShow
    }
]

export default routes;