import Vue from 'vue'
import DatePicker from 'vue2-datepicker'; import 'vue2-datepicker/index.css';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import Toast from "vue-toastification"; import "vue-toastification/dist/index.css";
import VueBootstrapTypeahead from 'vue-bootstrap-typeahead'
import VueApexCharts from 'vue-apexcharts'

import {
    NavbarPlugin,
    ButtonPlugin,
    FormPlugin,
    PaginationPlugin,
    BootstrapVueIcons,
    CardPlugin,
    FormTextareaPlugin,
    FormInputPlugin,
    FormGroupPlugin,
    TablePlugin,
    InputGroupPlugin,
    LayoutPlugin,
    FormSelectPlugin,
    FormCheckboxPlugin,
    TabsPlugin,
    FormTagsPlugin,
    FormSpinbuttonPlugin,
    ModalPlugin,
    DropdownPlugin
} from 'bootstrap-vue'

// Commponents
import componentHeaderList from "../components/component-header-list.vue"
import componentSearchList from "../components/component-search-list.vue"
import componentHeaderForm from "../components/component-header-form.vue"

// Libraries
import VueRouter from 'vue-router'

// plugins
import http from './http'
import url from './url'
import tools from './tools'


// Global registration
Vue.component('apexchart', VueApexCharts)
Vue.component('vue-bootstrap-typeahead', VueBootstrapTypeahead)

Vue.component('component-header-list', componentHeaderList)
Vue.component('component-search-list', componentSearchList)
Vue.component('component-header-form', componentHeaderForm)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('component-datepicker', DatePicker)

Vue.use(BootstrapVueIcons)
Vue.use(ButtonPlugin)
Vue.use(FormPlugin)
Vue.use(PaginationPlugin)
Vue.use(CardPlugin)
Vue.use(FormInputPlugin)
Vue.use(FormTextareaPlugin)
Vue.use(FormGroupPlugin)
Vue.use(TablePlugin)
Vue.use(InputGroupPlugin)
Vue.use(LayoutPlugin)
Vue.use(FormSelectPlugin)
Vue.use(FormCheckboxPlugin)
Vue.use(TabsPlugin)
Vue.use(FormTagsPlugin)
Vue.use(FormSpinbuttonPlugin)
Vue.use(ModalPlugin)
Vue.use(DropdownPlugin)
Vue.use(NavbarPlugin)

Vue.use(VueApexCharts)

library.add(fas)

// Libraries
Vue.use(VueRouter)
Vue.use(http)
Vue.use(url, system.url)
Vue.use(tools)
Vue.use(Toast, {
    timeout: 1500,
    hideProgressBar: true,
    position: 'bottom-right'
});

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