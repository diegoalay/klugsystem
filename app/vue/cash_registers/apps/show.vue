<script type="text/javascript">
    import componentForm from '../components/form_show.vue'
    export default {
        props: {
            user_cash_register: {
                type: Object,
                default: null
            }
        },
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                cash_register: {},
                id: null
            }
        },
        mounted(){
            if (this.user_cash_register) {
                this.cash_register = this.user_cash_register
            } else {
                this.setId()
                this.getData()
            }
        },
        methods:{
            setId(){
                this.id = this.$route.params.id
            },
            getData(){
                const url = this.url.build('cash_registers/:id', {id: this.id})

                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.cash_register = result.data
                    }else{
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    }
</script>

<template>
    <section>
        <component-header-form
            title="Caja"
        >
            <slot name="buttons">
                <b-button variant="outline-dark" class="mb-2" to="/cash_registers">
                    Listado <font-awesome-icon icon="list" />
                </b-button>

                <b-button v-if="!cash_register.closed" variant="outline-dark" class="mb-2" to="/sales/new">
                    Vender <font-awesome-icon icon="cart-shopping" />
                </b-button>

                <b-button v-if="!cash_register.closed" variant="outline-dark" class="mb-2" to="/expeditures/new">
                    Gasto <font-awesome-icon icon="money-bill-wave" />
                </b-button>
            </slot>
        </component-header-form>
        <component-form v-if="cash_register.id" :cash_register="cash_register"></component-form>
    </section>
</template>