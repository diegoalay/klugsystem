<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                event_type: {},
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
                console.log(this.id)
            },
            getData(){
                const url = this.url.config('event_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.event_type = result.data
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
            title="Tipos de evento">
        </component-header-form>
        <component-form :event_type="event_type"></component-form>
    </section>
</template>