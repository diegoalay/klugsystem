import moment from 'moment';

export default {
    install(Vue) {
        const datetime = (date) => {
            if (!date) return '-'

            return moment(date).format('DD/MM/YY HH:mm')
        }

        const date = (date) => {
            if (!date) return '-'

            return moment(date).format('DD/MM/YY')
        }

        const time = (date) => {
            if (!date) return '-'

            return moment(date).format('HH:MM')
        }

        const parseISOString = (date) => {
            if (date instanceof Date) {
                date = date.toISOString()
            }

            if (!date) return null

            let d = date.split(/\D+/)
            return new Date(Date.UTC(d[0], --d[1], d[2], d[3], d[4], d[5], d[6]));
        }

        const parse = (date) => {
            if (date instanceof Date) {
                date = date.toISOString()
            }

            return moment(date).format('YY-DD-MM')

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

        Vue.prototype.date = {
            getMonthsNameList,
            getMonthName,
            parseISOString,
            parse,
            datetime,
            date,
            time
        }
    }
}
