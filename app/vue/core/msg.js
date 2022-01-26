import { BVToastPlugin } from 'bootstrap-vue'

export default {

    install (Vue) {

        Vue.prototype.msg = {

            success(text, title) {
                vm.toast(`This is toast`, {
                    title: "BootstrapVue Toast",
                    autoHideDelay: 5000
                })
            }
        }
    }
}