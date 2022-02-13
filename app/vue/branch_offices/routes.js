import appBranchOfficesList  from './apps/list.vue'
import appBranchOfficesNew   from './apps/new.vue'
import appBranchOfficesShow from './apps/show.vue'

const routes =  [
    {
        path: "/branch_offices",
        component: appBranchOfficesList
    },
    {
        path: "/branch_offices/new",
        component: appBranchOfficesNew
    },
    {
        path: "/branch_offices/:id",
        component: appBranchOfficesShow
    }
]

export default routes;