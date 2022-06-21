export default {
    install(Vue) {
        const formatCurrency = (value) => {
            value = parseNumber(value)

            let val = (value/1).toFixed(2).replace(',', '.')
            return val.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
        }

        const formatPercentage = (value) => {
            return formatCurrency(value)
        }

        const parseNumber = (value) => {
            if (Number.isNaN(value) || value === '' || value === undefined) value = 0

            return value
        }

        Vue.prototype.number = {
            formatCurrency,
            formatPercentage
        }
    }
}