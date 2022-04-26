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
                const url = this.url.finance('cash_registers/:id', {id: this.id})

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
                <b-button variant="outline-dark" class="mb-2" to="/finance/cash_registers">
                    Listado <font-awesome-icon icon="list" />
                </b-button>
            </slot>
        </component-header-form>
        <component-form v-if="cash_register.id" :cash_register="cash_register"></component-form>
    </section>
</template>