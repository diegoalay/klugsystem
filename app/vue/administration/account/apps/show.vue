<script type="text/javascript">
    import componentForm from '../components/form.vue'

    export default {
        components:{
            'component-form': componentForm
        },
        props: {

        },
        data() {
            return {
                account: {
                    id: null
                }
            }
        },
        mounted(){
            this.getData()
        },
        methods:{
            getData(){
                const url = this.url.admin('account')
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.account = result.data
                    } else {
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
            title="Configuración de la cuenta"
            :show-buttons="false"
        >
        </component-header-form>
        <component-form :account="account"></component-form>
    </section>
</template>