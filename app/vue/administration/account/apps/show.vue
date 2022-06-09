<script type="text/javascript">
import componentForm from 'vueApp/administration/account/components/form.vue'
import componentFormBilling from 'vueApp/administration/account/components/form-billing.vue'

export default {
    components:{
        'component-form': componentForm,
        'component-form-billing': componentFormBilling
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
        <div>
            <b-card no-body>
                <b-tabs card>
                    <b-tab title="General" active>
                        <component-form :account="account"></component-form>
                    </b-tab>
                    <b-tab title="Facturación" v-if="account.id">
                        <component-form-billing :account="account"></component-form-billing>
                    </b-tab>
                </b-tabs>
            </b-card>
        </div>
    </section>
</template>