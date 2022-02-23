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
            return "https://klugsystem-public-storage.s3.us-east-1.amazonaws.com/assets/images/product-default.png?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEBAaCXVzLWVhc3QtMiJHMEUCIQClW1Bufs1cHTCD9qj6Quoi%2FxaoJg6oyZK6cUp3JgapPQIgWBd3nWCNypFpZaZGu%2BD1YH%2BmcWjgTRLIl9rMP3cErB4q5AIIaRAAGgw2MjkxMzk1NDUwODgiDPVWsi1EgRC9AmZhYSrBAqJE74iS6s3uOzmkwxbsa8yLdtwnmz7VP5qY2QPwT%2FGOHWu1b5I3DpOFTLt%2F2TJI0c4JsmElJze55uP8TjbqKutRSHlLDmcu8VnI5bcP3BpUhjkG1pA59NdJfwu3Te2ZlpY0WVOuiLudFphhpu2EWX34QBQwWtDrvF7UuEb3bXwFtzXVJlYvcX6fdEnI9iKmQDaUS7f%2FD9m01ZkZ0dAqwq1dvRGgx57qNf6KFE2a0biGxDkkKBXVtJWuTAvaEWirMxPMvBtbrVbiAm5Hzzm9D5Myp5dctzJ97tYR4Tkz2rOiY1RnI3BSpZonBdBPd%2FfnFYmBMYZLzPYxMjteAxSVMaSlq0Jcj9rI%2B2fiMr9DwIXNlVNVwXjV70ED9r5gEDVwu%2BoTRbXn1l%2BK2djgL3T3KeoxYHXpc5UCd37KbUlyIeGNuTDh8tWQBjqzAjDTQjBCjG%2FgJUmpSyPU3ksIoxvW1bsQaKGHYoWxd0FjrwjMrgY%2FvIwj4y9XNM5sIZYHWP1fmXjTfUcqKnmNceDpXYFlkRBJmctZS%2FNqlwfmrZ1aWrlh%2BDc7g%2F0D1MAT9nQHdvnQNNHyLiXbyeNv6qTcupDc9sBYQcxTquhcFEM1ithpgUVlsBwRPqLKR6OulOSq4DxLU4ckv1h0LknyoCENlYR4E4%2FRT04KnAJOIRGPuKTlv8slagLZN5ks0WJIemdhlQjw807RGpX5xDdXQ9azDxvr%2FRkBj7K0AFn3SWZAtmWVt1DCUojf%2BRywBHSg1zx724Hnw1%2FmYuI9F4UtdA44BtoNpSskKI5%2Btug0eStBvRXVI3B5ca1aSiQFxCPWaA5vU8jvAeej%2BFCGgQm7Iwm4rnU%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220223T000213Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Credential=ASIAZE65DTQACJAV5J2T%2F20220223%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=2c0c726729897f9b58469109a9748b75572a609ab7e38779fa5269ca37aefd3e"
        }

        const getEmployeeImage = () => {
            return "https://klugsystem-public-storage.s3.us-east-1.amazonaws.com/assets/images/employee-default.png?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEBAaCXVzLWVhc3QtMiJHMEUCIQClW1Bufs1cHTCD9qj6Quoi%2FxaoJg6oyZK6cUp3JgapPQIgWBd3nWCNypFpZaZGu%2BD1YH%2BmcWjgTRLIl9rMP3cErB4q5AIIaRAAGgw2MjkxMzk1NDUwODgiDPVWsi1EgRC9AmZhYSrBAqJE74iS6s3uOzmkwxbsa8yLdtwnmz7VP5qY2QPwT%2FGOHWu1b5I3DpOFTLt%2F2TJI0c4JsmElJze55uP8TjbqKutRSHlLDmcu8VnI5bcP3BpUhjkG1pA59NdJfwu3Te2ZlpY0WVOuiLudFphhpu2EWX34QBQwWtDrvF7UuEb3bXwFtzXVJlYvcX6fdEnI9iKmQDaUS7f%2FD9m01ZkZ0dAqwq1dvRGgx57qNf6KFE2a0biGxDkkKBXVtJWuTAvaEWirMxPMvBtbrVbiAm5Hzzm9D5Myp5dctzJ97tYR4Tkz2rOiY1RnI3BSpZonBdBPd%2FfnFYmBMYZLzPYxMjteAxSVMaSlq0Jcj9rI%2B2fiMr9DwIXNlVNVwXjV70ED9r5gEDVwu%2BoTRbXn1l%2BK2djgL3T3KeoxYHXpc5UCd37KbUlyIeGNuTDh8tWQBjqzAjDTQjBCjG%2FgJUmpSyPU3ksIoxvW1bsQaKGHYoWxd0FjrwjMrgY%2FvIwj4y9XNM5sIZYHWP1fmXjTfUcqKnmNceDpXYFlkRBJmctZS%2FNqlwfmrZ1aWrlh%2BDc7g%2F0D1MAT9nQHdvnQNNHyLiXbyeNv6qTcupDc9sBYQcxTquhcFEM1ithpgUVlsBwRPqLKR6OulOSq4DxLU4ckv1h0LknyoCENlYR4E4%2FRT04KnAJOIRGPuKTlv8slagLZN5ks0WJIemdhlQjw807RGpX5xDdXQ9azDxvr%2FRkBj7K0AFn3SWZAtmWVt1DCUojf%2BRywBHSg1zx724Hnw1%2FmYuI9F4UtdA44BtoNpSskKI5%2Btug0eStBvRXVI3B5ca1aSiQFxCPWaA5vU8jvAeej%2BFCGgQm7Iwm4rnU%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20220223T034500Z&X-Amz-SignedHeaders=host&X-Amz-Expires=604800&X-Amz-Credential=ASIAZE65DTQACJAV5J2T%2F20220223%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=7b20692480075aec51c1ddb29da01429b14b33ca541abba411215338a0e3a1db"
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
            getProductImage,
            getEmployeeImage
        }
    }
}