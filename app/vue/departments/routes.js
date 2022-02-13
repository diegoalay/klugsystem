import appDepartmentsList  from './apps/list.vue'
import appDepartmentsNew   from './apps/new.vue'
import appDepartmentsShow from './apps/show.vue'


const routes =  [
    {
        path: "/departments",
        component: appDepartmentsList
    },
    {
        path: "/departments/new",
        component: appDepartmentsNew
    },
    {
        path: "/departments/:id",
        component: appDepartmentsShow
    }
]

export default routes;