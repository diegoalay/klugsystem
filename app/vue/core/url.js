export default {

    install (Vue) {
    
        Vue.prototype.url = {

            // · Redirect to specific url
            go(url=null) {
                url = new URL(url, leslicloud_request.root_url)
                window.location.href = url.href;
            },

            // · Get well formated url
            to(path=null) {

                if (path) {
                    return new URL(path, leslicloud_request.root_url)    
                }

                return new URL("/", leslicloud_request.root_url)

            }

        }

    }
    
}
