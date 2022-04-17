import appBranchOfficesList  from 'vueApp/administration/branch_offices/apps/list.vue'
import appBranchOfficesNew   from 'vueApp/administration/branch_offices/apps/new.vue'
import appBranchOfficesShow from 'vueApp/administration/branch_offices/apps/show.vue'

const routes =  [
    {
        path: "/administration/branch_offices",
        component: appBranchOfficesList
    },
    {
        path: "/administration/branch_offices/new",
        component: appBranchOfficesNew
    },
    {
        path: "/administration/branch_offices/:id",
        component: appBranchOfficesShow
    }
]

export default routes;