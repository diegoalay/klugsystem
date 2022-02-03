// import { useToast } from 'vue-toastification'

// Import the CSS or use your own!
// import "vue-toastification/dist/index.css";

export default {
    install (Vue) {
        Vue.prototype.msg = {

            success(message) {
                console.log(this._vm)
                // toast.success("incremented!")
            }

        }

    }
}
