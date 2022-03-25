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
                contact: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear contacto">
        </component-header-form>
        <component-form :contact="contact"></component-form>
    </section>
</template>