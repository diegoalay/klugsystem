import app from '../core/app'

import appList  from './apps/list.vue'

app( "/products", [{
    path: "/",
    component: appList
}])