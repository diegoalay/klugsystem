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
                provider: {}
            }
        },
    }
</script>

<template>
    <section>
        <component-header-form
            title="Crear proveedor">
        </component-header-form>
        <component-form :provider="provider"></component-form>
    </section>
</template>