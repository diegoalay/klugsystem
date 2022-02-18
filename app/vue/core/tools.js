import http from './http'

export default {

    install (Vue) {
        const isMobile = () => {
            if( screen.width <= 760 ) {
                return true;
            }
            else {
                return false;
            }
        }

        const userDetails = () => {
            const url = 'users/details'

            http.get(url).then(result => {
                if (result.successful) {
                    return result.data
                }
            }).catch(error => {
                console.log(error)
            })
        }

        Vue.prototype.tools = {
            isMobile,
            userDetails
        }
    }
}