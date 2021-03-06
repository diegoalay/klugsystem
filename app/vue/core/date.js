import moment from 'moment';

export default {
    install(Vue, tools) {
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

        const daysInMonth = (month, year) =>  {
            return new Date(year, month, 0).getDate();
        }

        Vue.prototype.date = {
            daysInMonth,
            parseISOString,
            parse,
            datetime,
            date,
            time
        }
    }
}
