import app from '../core/app'

import appList  from './apps/list.vue'
import appNew   from './apps/new.vue'
import appShow from './apps/show.vue'

app( "/catalog/event_types", [{
    path: "/",
    component: appList
},{
    path: "/new",
    component: appNew
},{
    path: "/:id",
    component: appShow
}])