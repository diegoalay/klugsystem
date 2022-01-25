import Vue from 'vue'
import DatePicker from 'vue2-datepicker';
import { library } from '@fortawesome/fontawesome-svg-core'
import { BootstrapVue, BootstrapVueIcons } from 'bootstrap-vue'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import componentHeaderList from "../components/component-header-list.vue"
import componentHeaderForm from "../components/component-header-form.vue"
import Notifications from 'vue-notification'
import VueRouter from 'vue-router'
import http from './http'
import url from './url'

library.add(fas)

import VueBootstrapTypeahead from 'vue-bootstrap-typeahead'
// Global registration
Vue.component('vue-bootstrap-typeahead', VueBootstrapTypeahead)

Vue.component('component-header-list', componentHeaderList)
Vue.component('component-header-form', componentHeaderForm)
Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('component-datepicker', DatePicker)
Vue.use(Notifications)
Vue.use(BootstrapVueIcons)
Vue.use(BootstrapVue)
Vue.use(VueRouter)
Vue.use(http)
Vue.use(url)

export default (base_path, routes=[]) => {
    //app builder
    let app_builder = { }

    // · Routes for SPAs
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