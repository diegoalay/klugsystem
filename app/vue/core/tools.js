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
                const url = `/inventory/products/${product.id}/files/${product.product_file_id}`
                return url
            }

            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/product-default.png"
        }

        const getEmployeeImage = () => {
            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/employee-default.png"
        }

        const printSale = (sale) => {
            const url = `/finance/sales/${sale.id}.pdf`

            window.open(url, '_blank')
        }

        const printSales = (url) => {
            window.open(`${url}.pdf`, '_blank')
        }

        const printQuotation = (quotation_id) => {
            const url = `/finance/quotations/${quotation_id}.pdf`

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

        const getMonthName = (idx, locale = null) => {

            let objDate = new Date();
            objDate.setDate(1);
            objDate.setMonth(idx-1);

            let languaje = locale ? locale : getLocale()

            const month  = objDate.toLocaleString(languaje, { month: "long" })

            return (month.charAt(0).toUpperCase() + month.slice(1))
        }


        const getMonthsNameList = (start = 1, end = 12) => {
            let months = []

            for (let i = start; i <= end; i ++) {
                months.push(getMonthName(i))
            }

            return months
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
            printSales,
            printQuotation,
            roleCanBeEdited,
            productTransactionCanBeEdited,
            getMonthName,
            getMonthsNameList
        }
    }
}