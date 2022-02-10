import app from '../core/app'

import appList  from './apps/list.vue'

app( "/", [{
    path: "/",
    component: appList
}])