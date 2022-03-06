import Vue from 'vue'
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import Toast from "vue-toastification"; import "vue-toastification/dist/index.css";

import {
    ButtonPlugin,
    FormPlugin,
    CardPlugin,
    FormInputPlugin,
    FormGroupPlugin,
    LayoutPlugin,
} from 'bootstrap-vue'

// Libraries
import VueRouter from 'vue-router'

// plugins
import http from './http'
import url from './url'

Vue.use(ButtonPlugin)
Vue.use(FormPlugin)
Vue.use(CardPlugin)
Vue.use(FormInputPlugin)
Vue.use(FormGroupPlugin)
Vue.use(LayoutPlugin)

// Global registration
Vue.component('font-awesome-icon', FontAwesomeIcon)

// Libraries
Vue.use(VueRouter)
Vue.use(http)
Vue.use(url, system.url)
Vue.use(Toast, {
    timeout: 2000,
    hideProgressBar: true,
    position: 'bottom-right',
    icon: {
        iconClass: 'xmark'
    }
});

library.add(fas)

export default (base_path, routes=[]) => {
    //app builder
    let app_builder = { }

    // · Routes
    app_builder['router'] = new VueRouter({
        linkActiveClass: 'is-active',
        mode: 'history',
        hash: false,
        base: base_path,
        routes: routes
    })

    // · Building Vue cloud app
    let app = new Vue(app_builder)

    // · Mount app once DOM is ready
    app.$mount("#app")
}