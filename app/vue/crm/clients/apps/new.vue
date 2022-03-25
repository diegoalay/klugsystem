<script type="text/javascript">
    import componentForm from '../components/form.vue'
    export default {
        components:{
            'component-form': componentForm
        },
        mounted(){
        },
        props: {},
        data() {
            return {
                client: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear cliente">
        </component-header-form>
        <component-form :client="client"></component-form>
    </section>
</template>