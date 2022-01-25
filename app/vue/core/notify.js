export default {
    install (Vue) {
        Vue.prototype.notify = {
            success(text, title) {
                this.$notify({
                    groups: "foo",
                    title,
                    text
                })
            }  
        }
    }   
}