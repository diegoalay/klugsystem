
export default {
    install (Vue, store) {
        let default_data = {
            global: {
                privileges: []
            }
        }

        store = { ...store, ...default_data }

        Vue.prototype.store = Vue.observable(store)
    }
}
