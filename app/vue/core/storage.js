export default {

    install (Vue, options) {
        const app_id = 'klugsystem'

        var storage_local_key = app_id.concat("-").concat(options.current_user.id)

        var storageKey = key => storage_local_key.concat("-").concat(key)

        var storageKeyGlobal = key => app_id.concat("-").concat(key)

        let local = (key, data=null) => {

            if (data) {
                localStorage.setItem(storageKey(key), JSON.stringify(data))
                return
            }

            if (!localStorage.getItem(storageKey(key))) return {}
            return JSON.parse(localStorage.getItem(storageKey(key)))

        }

        let session = (key, data=null) => {

            if (data) {
                sessionStorage.setItem(storageKey(key), JSON.stringify(data))
                return
            }

            return JSON.parse(sessionStorage.getItem(storageKey(key)))

        }

        let global = (key, data=null) => {

            if (data) {
                localStorage.setItem(storageKeyGlobal(key), JSON.stringify(data))
                return
            }

            return JSON.parse(localStorage.getItem(storageKeyGlobal(key)))

        }

        Vue.prototype.storage = {
            local,
            session,
            global
        }
    }
}
