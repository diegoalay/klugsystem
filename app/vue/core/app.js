// import Vuex from 'vuex'
import Vue from 'vue'
import DatePicker from 'vue2-datepicker'; import 'vue2-datepicker/index.css';
import { library } from '@fortawesome/fontawesome-svg-core'
import { fas } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import Toast from 'vue-toastification'; import 'vue-toastification/dist/index.css';
import VueApexCharts from 'vue-apexcharts'
import VModal from 'vue-js-modal'
import VueI18n from 'vue-i18n'
import ActionCableVue from 'actioncable-vue';
import VueConfirmDialog from 'vue-confirm-dialog'
import Dialog from 'bootstrap-vue-dialog'


import {
    FormRadioPlugin,
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
    DropdownPlugin,
    ImagePlugin,
    CarouselPlugin,
} from 'bootstrap-vue'

// Commponents
import componentFiles from '../components/shared/component-files.vue'
import componentHeaderList from '../components/component-header-list.vue'
import componentSearchList from '../components/component-search-list.vue'
import componentHeaderForm from '../components/component-header-form.vue'

// Libraries
import VueRouter from 'vue-router'

// plugins
import http from './http'
import url from './url'
import tools from './tools'
import date from './date'
import store from './store'

// Global registration
Vue.component('apexchart', VueApexCharts)

Vue.component('component-files', componentFiles)
Vue.component('component-header-list', componentHeaderList)
Vue.component('component-search-list', componentSearchList)
Vue.component('component-header-form', componentHeaderForm)

Vue.component('font-awesome-icon', FontAwesomeIcon)
Vue.component('component-datepicker', DatePicker)

Vue.use(FormRadioPlugin)
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
Vue.use(ImagePlugin)
Vue.use(VModal)
Vue.use(CarouselPlugin)
Vue.use(VueApexCharts)
Vue.use(VueConfirmDialog)
Vue.use(Dialog)
library.add(fas)

// Libraries
Vue.use(VModal, { componentName: 'modal' })
Vue.use(VueRouter)
Vue.use(http)
Vue.use(url, system.url)
Vue.use(tools)
Vue.use(date, tools)
Vue.use(store, system)
Vue.use(Toast, {
    timeout: 1500,
    hideProgressBar: true,
    position: 'bottom-right',
    icon: {
        iconClass: 'xmark'
    }
})

Vue.use(ActionCableVue, {
    debug: true,
    debugLevel: 'error',
    connectionUrl: 'ws://klugsystem:3000/cable', // or function which returns a string with your JWT appended to your server URL as a query parameter
    connectImmediately: true,
})

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

    app_builder['channels'] = {
        RolesChannel: {
            connected() {},
            rejected() {},
            received(response) {
                this.store.global.abilities = response.data


                this.abilitiesDiff()
            },
            disconnected() {},
        },
    }

    app_builder['methods'] = {
        abilitiesDiff: function (){
            this.store.global.menu_items.forEach(item => {
                const el = document.getElementById(item.key)
                if (el) {
                    const find = this.store.global.abilities.find(e => e.key == item.key)

                    let styles = {
                        opacity: 0,
                        visibility: 'hidden',
                        display: 'none'
                    }

                    if (find) {
                        console.log(item.key)
                        styles = {
                            opacity: 1,
                            visibility: 'visible',
                            display: 'block'
                        }
                    }

                    el.style.setProperty('opacity', styles.opacity)
                    el.style.setProperty('visibility', styles.visibility)
                    el.style.setProperty('display', styles.display)
                }
            })
        },

        sendMessage: function () {
            this.$cable.perform({
                channel: "RolesChannel",
                action: "send_message",
                data: {
                    content: this.message,
                },
            });
        }
    }

    app_builder['mounted'] = function(){
        this.$cable.subscribe(
            {
                channel: 'RolesChannel',
                id: system.current_user.role.id
            }
        );
    }

    // · Building Vue cloud app
    let app = new Vue({
        ...app_builder
    })

    // · Mount app once DOM is ready
    app.$mount('#app')
}