<script type="text/javascript">
import appNewCashRegister from 'vueApp/pos/cash_registers/components/form_new.vue'
import appShowCashRegister from 'vueApp/pos/cash_registers/components/form_show.vue'

export default {
    components:{
        'component-new-cash-register': appNewCashRegister,
        'component-show-cash-register': appShowCashRegister
    },
    data() {
        return {
            finished: false
        }
    },
    mounted(){
        this.getData()
    },
    methods:{
        getData(){
            const url = this.url.pos('cash_register')
            this.http.get(url).then(result => {
                if (result.successful) {
                    const cash_register = result.data ? result.data : { id: null }

                    this.$set(this.store.global, 'cash_register', cash_register)
                } else {
                    this.$toast.error(result.error.message)
                }

                this.finished = true
            }).catch(error => {
                console.log(error)
            })
        }
    }
}
</script>

<template>
    <div>
        <component-show-cash-register v-if="store.global.cash_register.id && finished" />
        <component-new-cash-register v-if="!store.global.cash_register.id" />
    </div>
</template>