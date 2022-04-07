import appDepartmentsList  from 'vueApp/inventory/departments/apps/list.vue'
import appDepartmentsNew   from 'vueApp/inventory/departments/apps/new.vue'
import appDepartmentsShow from 'vueApp/inventory/departments/apps/show.vue'


const routes =  [
    {
        path: "/inventory/departments",
        component: appDepartmentsList
    },
    {
        path: "/inventory/departments/new",
        component: appDepartmentsNew
    },
    {
        path: "/inventory/departments/:id",
        component: appDepartmentsShow
    }
]

export default routes;