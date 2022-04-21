import appHrEmployeesList  from 'vueApp/hr/employees/apps/list.vue'
import appHrEmployeesNew   from 'vueApp/hr/employees/apps/new.vue'
import appHrEmployeesShow from 'vueApp/hr/employees/apps/show.vue'

const routes =  [
    {
        path: "/hr/employees",
        component: appHrEmployeesList
    },
    {
        path: "/hr/employees/new",
        component: appHrEmployeesNew
    },
    {
        path: "/hr/employees/:id",
        component: appHrEmployeesShow
    }
]

export default routes;