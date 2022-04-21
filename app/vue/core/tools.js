import http from './http'

export default {

    install (Vue) {
        const screenWidth = () => {
            return screen.width
        }

        const screenHeight = () => {
            return screen.height
        }

        const isMobile = () => {
            if (screenWidth() <= 760 ) {
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

        const getLocale = () => {
            if (navigator.languages != undefined)
              return navigator.languages[0];
            return navigator.language;
        }

        const getCurrentYear = () => {
            return new Date().getFullYear()
        }

        const getCurrentMonth = () => {
            return new Date().getMonth()
        }

        const getProductImage = (product) => {
            if (product && product.product_file_id) {
                const url = `/products/${product.id}/files/${product.product_file_id}`
                return url
            }

            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/product-default.png"
        }

        const getEmployeeImage = () => {
            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/employee-default.png"
        }

        const printSale = (sale_id) => {
            const url = `/finance/sales/${sale_id}.pdf`

            window.open(url, '_blank')
        }

        const roleCanBeEdited = (role) => {
            if (role.code === 'admin') {
                return false
            }

            return true
        }

        const productTransactionCanBeEdited = (catalog_product_transaction_type) => {
            if (catalog_product_transaction_type.code === 'product-sale') {
                return false
            }

            return true
        }

        Vue.prototype.tools = {
            isMobile,
            screenWidth,
            screenHeight,
            userDetails,
            getLocale,
            getCurrentYear,
            getCurrentMonth,
            getProductImage,
            getEmployeeImage,
            printSale,
            roleCanBeEdited,
            productTransactionCanBeEdited
        }
    }
}