export default {
    install (Vue, options) {
        const isMobile = () => {
            if( screen.width <= 760 ) {
                return true;
            }
            else {
                return false;
            }
        }

        Vue.prototype.tools = {
            isMobile
        }
    }
}