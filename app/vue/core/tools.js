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

        const getProductImage = () => {
            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/product-default.png"
        }

        const getEmployeeImage = () => {
            return "https://klugsystem-public-storage.s3.amazonaws.com/assets/images/employee-default.png"
        }

        const parseISOString = (date) => {
            if (!date) return null 
            
            let d = date.split(/\D+/)
            return new Date(Date.UTC(d[0], --d[1], d[2], d[3], d[4], d[5], d[6]));
        }

        Vue.prototype.tools = {
            isMobile,
            screenWidth,
            screenHeight,
            userDetails,
            getLocale,
            getMonthsNameList,
            getMonthName,
            getCurrentYear,
            getCurrentMonth,
            getProductImage,
            getEmployeeImage,
            parseISOString
        }
    }
}