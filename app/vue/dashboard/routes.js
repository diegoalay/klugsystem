import appDashboardList  from 'vueApp/dashboard/apps/list.vue'

const routes =  [
    {
        path: "/dashboard",
        component: appDashboardList
    },
    {
        path: "/",
        component: appDashboardList
    }
]

export default routes;