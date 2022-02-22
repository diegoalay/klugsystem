import http from './http'

export default {

    install (Vue) {
        const screenWidth = () => {
            return screen.width
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
            return "https://klugsystem-public-storage.s3.us-east-1.amazonaws.com/assets/images/product-default.png?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEPz%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMiJHMEUCIQCZ%2FuA7r%2FbEqeOqoJDYtVgr5MwN4EZiH3VEagHJVHvRhQIgZRbapSQ7dP4sdFKyB1usIw4Yrfz59qEo7XsL78mnXRIq5AIIVRAAGgw2MjkxMzk1NDUwODgiDJerDL0JAPIhu4oFDSrBAtD8EpgQBjcAItNoGjenLDn58UOEwkv4Vz7Egs74axyYlOvW0jCyeaAji4wPONlj%2FrgtbP1mePynL5T4uodGV8TgWrZtNt%2FEoL8x4u2dbWHEfF6SLb08BsYJx9MIL9q0aiC2c0aOgnCn6u3SIL9nEfPkIu5tqdX8mpzfFwRgUAXDynz4cj8GhX00eFMxotCjptGQxWV0M2nJAjrkjQtI%2BKTfLMPtxSIs9fkSGT%2BYZv6gKsJT%2FPxJ%2F1R7tSp492zrWyGlYFm%2F6%2FdurgFbK9kUmvHDFrvhWUmexRwr7IhImPsQ%2FFF3lQTBdsU59zjusBkHYlGJSdtVMTSEkKI4ePRC%2FanXvOPOAmOOUT0k34J58icwn3pO2907YiQ%2FWSFLNNyZPwBp80r5nwWus1ax%2FP3YC%2BOLt43DpRASoyzOpoPZQUxujjCKw9GQBjqzAkRXoihUlzDfTDrevcNQRcAUeUUi59reU6WD57F5XFrsAvIa9ViorDoGE7cOoROBsrqL3%2FczJYk5c4Qk1J1bftC%2Bdm8MpPP8mdupv9Hf6%2Bou0WwnEYpR4EIh2iVCD5OAEnVY0H3PTeXACr05jnu2zFqAMineM6gcLyyRJB2nnQfqTI0xISxjgKqV1wQwOplq2tKOLudeA1kiF53%2BkOZKNx1%2BkIDYft9ZJ%2FxKzlGXB87OXJPmC%2FuqSqBpxE%2F9U2Ad2sMhLCef5vbPr2TdDlsFhJmpqkg4sJazWvltUvCHTBXsco%2Fm%2BNL3s%2F3NQK7Y%2BFk0wZaSkjbz3UHf%2BYBZHwBFb5Whj7LXQsWP7BKmrsGX0W1idJQptMaCeOS0Tv%2FM0ube3V0uppx2D7OE36XPlMqT0ZEZ7YI%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220222T055735Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Credential=ASIAZE65DTQAN3BH6LUE%2F20220222%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=a82d5656057fef733f2206c8f05379248a8f40b3600437bc37bb1c8f842230a4"
        }

        Vue.prototype.tools = {
            isMobile,
            screenWidth,
            userDetails,
            getLocale,
            getMonthsNameList,
            getMonthName,
            getCurrentYear,
            getCurrentMonth,
            getProductImage
        }
    }
}