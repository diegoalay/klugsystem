<script type="text/javascript">
export default {
    props: {
        sale_types: {
            type: Array,
            required: true
        },
        total: {
            type: String,
            required: true
        }
    },
    data() {
        return {
        }
    },
    methods: {
        submitSale(sale_type){
            this.$emit('submit', sale_type)
        },

        getIcon(sale_type){
            console.log(this.sale_types.length)

            switch (sale_type) {
                case 'electronic_bill':
                    return 'envelope-open-text'
                case 'receipt':
                    return 'receipt'
                case 'bill':
                    return 'file-invoice-dollar'
                default:
                    return 'dollar-sign'
            }
        }
    }
}
</script>

<template>
    <section>
        <b-row v-if="sale_types">
            <b-col class="mt-2" :md="12 / sale_types.length" sm="12" v-for="sale_type in sale_types" :key="sale_type.value">
                <b-button block variant="success" @click="submitSale(sale_type.value)">
                    <font-awesome-icon :icon="getIcon(sale_type.value)"/> &nbsp; {{ sale_type.text }}
                </b-button>
            </b-col>
        </b-row>
        <br>
        <b-row>
            <b-col class="text-center">
                <b><h3> Total a pagar: {{ total }} </h3></b>
            </b-col>
        </b-row>
    </section>
</template>