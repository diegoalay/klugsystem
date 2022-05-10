
export default {
    install (Vue, options) {
        let default_data = {
            global: {
                cash_register: options.current_user.cash_register ? options.current_user.cash_register :
                                { id: null },
                account: options.account,
                abilities: options.current_user.abilities,
                menu_items: options.menu_items
            }
        }

        const store = { ...default_data }

        Vue.prototype.store = Vue.observable(store)
    }
}
