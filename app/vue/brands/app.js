import app from '../core/app'

import appList  from './apps/list.vue'
import appNew   from './apps/new.vue'
import appShow from './apps/show.vue'

app( "/brands", [{
    path: "/",
    component: appList
},{
    path: "/new",
    component: appNew, props: { viewType: 'new' }
},{
    path: "/:id",
    component: appShow, props: { viewType: 'edit' },
}])