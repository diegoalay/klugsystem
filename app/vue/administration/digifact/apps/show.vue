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
                digifact: {}
            }
        },
        mounted(){
            this.getData()
        },
        methods:{
            getData(){
                const url = this.url.admin('digifact')
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.digifact = result.data
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
            title="Digifact"
            :show-buttons="false"
        >
        </component-header-form>
        <component-form :digifact="digifact"></component-form>
    </section>
</template>