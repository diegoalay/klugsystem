import app from '../core/app_public'

import appNew   from './apps/new.vue'

app( "/", [{
    path: "/",
    component: appNew
}])