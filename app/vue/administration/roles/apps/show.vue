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
                role: {},
                id: null
            }
        },
        mounted(){
            this.setId()
            this.getData()
        },
        methods:{
            setId(){
                this.id = this.$route.params.id
            },
            getData(){
                const url = this.url.admin('roles/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.role = result.data
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
            title="rolees">
        </component-header-form>
        <component-form :role="role"></component-form>
    </section>
</template>