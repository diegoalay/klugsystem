<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        data() {
            return {
                catalog_event_type: {},
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
                const url = this.url.build('catalog/event_types/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.catalog_event_type = result.data
                    }else{

                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Tipos de evento">
        </component-header-form>
        <component-form :catalog_event_type="catalog_event_type"></component-form>
    </section>
</template>